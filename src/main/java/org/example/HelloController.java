package org.example;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.transaction.annotation.Transactional;


@Controller
public class HelloController {

    @Autowired
    private EditorContentRepository repository;
    @Autowired
    private NewsletterRepository newsletterRepository;
    @Autowired
    private ArticleRepository articleRepository;


    // Show the input form
    @GetMapping("/input")
    public String showInputForm() {
        return "input";
    }

    // Gets Home Page Data
    @GetMapping("/home")
    public String getNewsletters(Model model) {
        List<Newsletter> newsletters = newsletterRepository.findAll();
        List<HomeElements> newsletterData =  newsletters.stream()
                .map(newsletter -> new HomeElements(newsletter.getTitle(), newsletter.getYear(), newsletter.getQuarter(), newsletter.getStatus(), newsletter.getPublicationDate()))
                .collect(Collectors.toList());

        newsletterData.forEach(entry -> {
            System.out.println(entry.getTitle() + " " + entry.getYear() + " " + entry.getStatus() + " " + entry.getPublicationDate());
        });

        model.addAttribute("newsletters", newsletterData);
        return "home";
    }

    @GetMapping("/addnewsletter")
    @Transactional
    public String addNewsletter(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer quarter,
            Model model//,
            /*RedirectAttributes redirectAttributes*/) {

        try {
            // Set default values if not provided
            LocalDate now = LocalDate.now();
            Integer currentYear = now.getYear();
            Integer currentQuarter = ((now.getMonthValue() - 1) / 3) + 1;

            // Use provided values or defaults
            Integer selectedYear = (year != null) ? year : currentYear;
            Integer selectedQuarter = (quarter != null) ? quarter : currentQuarter;

            Newsletter nwletter = newsletterRepository.findByYearAndQuarter(selectedYear, selectedQuarter);

            if(nwletter == null) {
                nwletter = new Newsletter();
                nwletter.setYear(selectedYear);
                nwletter.setQuarter(selectedQuarter);
                nwletter.setTitle("" + selectedYear + " Quarter " + selectedQuarter);
                nwletter.setStatus("draft");
                nwletter = newsletterRepository.save(nwletter);  // Save and get the persisted entity
            }

            // Debug print
            System.out.println("Newsletter ID in addNewsletter: " + nwletter.getNewsletterId());

            List<Article> articles = articleRepository.getArticlesByNewsletter_NewsletterId(nwletter.getNewsletterId());

            model.addAttribute("articles", articles);
            model.addAttribute("newsletter", nwletter); // Add full newsletter object so frontend can get title
            model.addAttribute("newsletter_id", nwletter.getNewsletterId());
            model.addAttribute("year",selectedYear);
            model.addAttribute("quarter",selectedQuarter);


            //return "redirect:/newsletterhome";
            return "/newsletterhome";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/home";
        }
    }

    @GetMapping("/publishNewsletter")
public String publishNewsletter(@RequestParam Integer year,
                                @RequestParam Integer quarter,
                                Model model){

    Newsletter nwletter = newsletterRepository.findByYearAndQuarter(year, quarter);
    if (nwletter != null) {
        List<Article> articles = articleRepository.getArticlesByNewsletter_NewsletterId(nwletter.getNewsletterId());

        // Publish all draft articles
        for (Article a : articles){
            if(!a.getStatus().equals("published")){
                a.setStatus("published");
                articleRepository.save(a);
            }
        }
        
        nwletter.setStatus("published");
        newsletterRepository.save(nwletter);

        // Pass the necessary data for newsletterview.jsp
        model.addAttribute("newsletter", nwletter);
        model.addAttribute("articles", articles);
        
        // If you also need the newsletter list data
        List<Newsletter> newsletters = newsletterRepository.findAll();
        List<HomeElements> newsletterData = newsletters.stream()
            .map(newsletter -> new HomeElements(newsletter.getTitle(), 
                newsletter.getYear(), 
                newsletter.getQuarter(), 
                newsletter.getStatus(), 
                newsletter.getPublicationDate()))
            .collect(Collectors.toList());
        model.addAttribute("newsletters", newsletterData);  // For any other view that needs it
    }

    return "newsletterview";
}

    @GetMapping("/newsletterhome")
    @Transactional
    public String newsletterhome(@RequestParam Integer year,
                                 @RequestParam Integer quarter,
                                 Model model) {
        try {
            Newsletter nwletter = newsletterRepository.findByYearAndQuarter(year, quarter);
            if (nwletter != null) {
                List<Article> articles = articleRepository.getArticlesByNewsletter_NewsletterId(nwletter.getNewsletterId());

                // Debug print
                System.out.println("Newsletter ID: " + nwletter.getNewsletterId());
                System.out.println("Number of articles: " + (articles != null ? articles.size() : 0));

                model.addAttribute("articles", articles);
                model.addAttribute("newsletter", nwletter); // Add full newsletter object so frontend can get title
                model.addAttribute("newsletter_id", nwletter.getNewsletterId());
                model.addAttribute("year", year);
                model.addAttribute("quarter", quarter);
            } else {
                System.out.println("Newsletter not found for year: " + year + " and quarter: " + quarter);
            }
            return "newsletterhome";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/home";
        }
    }

    // new addition for updating the newsletter title - Anirudh
    @PostMapping("/updateNewsletterTitle")
    @Transactional
    public String updateNewsletterTitle(@RequestParam Long newsletterId,
                                        @RequestParam Integer year,
                                        @RequestParam Integer quarter,
                                        RedirectAttributes redirectAttributes) {
        // 1. Find the existing newsletter by ID
        Newsletter nwletter = newsletterRepository.findByNewsletterId(newsletterId);

        if (nwletter != null) {
            // 2. Update only the title field of the same newsletter

            nwletter.setYear(year);
            nwletter.setQuarter(quarter);
            nwletter.setTitle("" + year + " Quarter " + quarter);
            // 3. Save the updated newsletter back to database
            newsletterRepository.save(nwletter);
        }

        // 4. Redirect back to the newsletter page
        return "redirect:/newsletterhome?year=" + nwletter.getYear() + "&quarter=" + nwletter.getQuarter();
    }

    @GetMapping("/viewNewsletter")
    public String viewNewsletter(@RequestParam Integer year,
                               @RequestParam Integer quarter,
                               Model model) {
        Newsletter nwletter = newsletterRepository.findByYearAndQuarter(year, quarter);
        if (nwletter != null) {
            //List<Article> articles = articleRepository.getArticlesByNewsletter_NewsletterId(nwletter.getNewsletterId());
            List<Article> articles = articleRepository.getArticlesByNewsletter_NewsletterIdAndStatus(nwletter.getNewsletterId(), "published");

            model.addAttribute("newsletter", nwletter);
            model.addAttribute("articles", articles);
            return "newsletterview";
        }
        return "redirect:/home";
    }



    @GetMapping("/addarticle")
    @Transactional
    public String addarticle(@RequestParam Long newsletterId, Model model) {
        try {
            Newsletter newsletter = newsletterRepository.findByNewsletterId(newsletterId);
            if (newsletter == null) {
                return "redirect:/home";
            }
            model.addAttribute("newsletter_id", newsletterId);
            model.addAttribute("year", newsletter.getYear());        // Added this for better routing
            model.addAttribute("quarter", newsletter.getQuarter());  // Added this
            return "addarticle";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/home";
        }
    }

    /*
        Edit Article
        Will be called when someone wants to edit an article
        @GetMapping("/edit")
        public String editContent(@RequestParam("id") Long id, Model model) {
            // Fetch content from the database by ID
            EditorContent content = repository.findById(id).orElse(null);
            if (content != null) {
                model.addAttribute("name", content.getContent());
            }
            return "input";  // Show the content in CKEditor for editing
        }
     */

    @GetMapping("/editArticle")
    public String editArticle(@RequestParam("id") Long id, Model model) {
        Article content = articleRepository.findById(id).orElse(null);

        System.out.println(content.getTitle());
        if (content!= null) {

            //Newsletter nwletter= newsletterRepository.findByYearAndQuarter();
            model.addAttribute("title", content.getTitle());
            model.addAttribute("subTitle", content.getSubtitle());
            model.addAttribute("date", content.getAddedDate());
            model.addAttribute("metaTitle", content.getMetaTitle());
            model.addAttribute("metaDescription", content.getMetaDescription());
            model.addAttribute("summary", content.getSummary());
            model.addAttribute("newsletterContent", content.getContent());
            model.addAttribute("newsletter_id",content.getNewsletter().getNewsletterId());
            model.addAttribute("articleId",id);
        }
        return "editarticle";
    }



    @GetMapping("/articleSave")
    @Transactional
    public String submitArticle(@RequestParam("title") String title,
                                @RequestParam("subtitle") String subtitle,
                                @RequestParam("metatitle") String metatitle,
                                @RequestParam("metadescription") String metadescription,
                                @RequestParam("summary") String summary,
                                @RequestParam("date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date date,
                                @RequestParam("content") String content,
                                @RequestParam("newsletterId") Long nwletterId,
                                @RequestParam(value = "articleId", required = false) Long articleId,
                              Model model){
        System.out.println("Called article Save.");

        //Check if article exists if id is given as input if not then make new article
        Article article;
        if(articleId!=null) {
            article = articleRepository.findById(articleId).orElse(null);

            if(article!=null){
                article.setTitle(title);
                article.setSubtitle(subtitle);
                article.setSummary(summary);
                article.setMetaTitle(metatitle);
                article.setMetaDescription(metadescription);
                article.setAddedDate(date);
                article.setContent(content);
                System.out.println("I am in edit");
            }else{
                System.out.println("Something is wrong");
            }
        }
        else{
            article = new Article();
            article.setTitle(title);
            article.setSubtitle(subtitle);
            article.setSummary(summary);
            article.setMetaTitle(metatitle);
            article.setMetaDescription(metadescription);
            article.setAddedDate(date);
            article.setContent(content);
        }

        //Fetch newsletter by id
        Newsletter nl=newsletterRepository.findByNewsletterId(nwletterId);
        article.setNewsletter(nl);
        article.setStatus("draft");


        articleRepository.save(article);
        //Newsletter nwletter = newsletterRepository.findByYearAndQuarter(year,quarter);
        List<Article> articles=articleRepository.getArticlesByNewsletter_NewsletterId(nl.getNewsletterId());
        model.addAttribute("articles",articles);
        model.addAttribute("year",nl.getYear());
        model.addAttribute("quarter",nl.getQuarter());
        model.addAttribute("newsletter_id",nl.getNewsletterId());

        //Make the entire thing single page
        return "newsletterhome";
    }

    @GetMapping("/publishArticle")
    public String publishArticle(@RequestParam("id") Long id,
                                 @RequestParam("newsletterId") Long nwletterId,
                                 Model model){

        //Fetch Article
        Article article=articleRepository.findById(id).orElse(null);

        if(article!=null){

            //Change status to publish
            article.setStatus("published");
            articleRepository.save(article);

        }

        //Fetch newsletter by id
        Newsletter nl=newsletterRepository.findByNewsletterId(nwletterId);
        List<Article> articles=articleRepository.getArticlesByNewsletter_NewsletterId(nl.getNewsletterId());
        model.addAttribute("articles",articles);
        model.addAttribute("year",nl.getYear());
        model.addAttribute("quarter",nl.getQuarter());
        model.addAttribute("newsletter_id",nl.getNewsletterId());

        return "newsletterhome";

    }

    @GetMapping("/articleview")
    public String viewArticle(@RequestParam("id") Long id, Model model){

        Article article=articleRepository.findById(id).orElse(null);

        if(article!=null){
            model.addAttribute("article",article);
            return "userarticleview";
        }

        return "error finding article";
    }

    // Handle form submission and save content
    @PostMapping("/display")
    public String saveContent(@RequestParam("name") String name, Model model) {
        System.out.println("Received content: " + name);
        // Create and save the content to the database
        EditorContent content = new EditorContent();
        content.setContent(name);
        repository.save(content);

        //return "Thank you"

        // Fetch the saved content to display
        model.addAttribute("name", name);
        model.addAttribute("id", content.getId());
        return "display";  // Display the submitted content
    }

    // Show the edit form with existing content
    @GetMapping("/edit")
    public String editContent(@RequestParam("id") Long id, Model model) {
        // Fetch content from the database by ID
        EditorContent content = repository.findById(id).orElse(null);
        if (content != null) {
            model.addAttribute("name", content.getContent());
        }
        return "input";  // Show the content in CKEditor for editing
    }

    @GetMapping("/all-entries")
    public String listAllEntries(Model model) {
        // Fetch all entries from the database
        List<EditorContent> allEntries = repository.findAll();

        // Debug: Print the size of the content and length
        allEntries.forEach(entry -> {
            System.out.println("Retrieved entry (ID: " + entry.getId() + "): " + entry.getContent());
            System.out.println("Content length: " + entry.getContent().length());
        });

        model.addAttribute("entries", allEntries);  // Pass the list of entries to the JSP page
        return "list";  // Return the name of the JSP page that will display the list
    }

}
