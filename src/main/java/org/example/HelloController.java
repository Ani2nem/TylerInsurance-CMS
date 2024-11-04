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
                .map(newsletter -> new HomeElements(newsletter.getTitle(), newsletter.getYear(), newsletter.getStatus(), newsletter.getPublicationDate()))
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
            Model model) {

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
            model.addAttribute("newsletter_id", nwletter.getNewsletterId());

            return "newsletterhome";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/home";
        }
    }

    @GetMapping("/newsletterhome")
    @Transactional
    public String newsletterhome(@RequestParam(required = false) Integer year,
                                 @RequestParam(required = false) Integer quarter,
                                 Model model) {
        try {
            Newsletter nwletter = newsletterRepository.findByYearAndQuarter(year, quarter);
            if (nwletter != null) {
                List<Article> articles = articleRepository.getArticlesByNewsletter_NewsletterId(nwletter.getNewsletterId());

                // Debug print
                System.out.println("Newsletter ID: " + nwletter.getNewsletterId());
                System.out.println("Number of articles: " + (articles != null ? articles.size() : 0));

                model.addAttribute("articles", articles);
                model.addAttribute("newsletter_id", nwletter.getNewsletterId());
            } else {
                System.out.println("Newsletter not found for year: " + year + " and quarter: " + quarter);
            }
            return "newsletterhome";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/home";
        }
    }



    @GetMapping("/addarticle")
    @Transactional
    public String addarticle1(@RequestParam Long newsletterId, Model model) {
        try {
            Newsletter newsletter = newsletterRepository.findByNewsletterId(newsletterId);
            if (newsletter == null) {
                return "redirect:/home";
            }
            model.addAttribute("newsletter_id", newsletterId);
            return "addarticle";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/home";
        }
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
                                @RequestParam("status") String status,
                              Model model){
        System.out.println("Called article Save.");
        Article article=new Article();
        article.setTitle(title);
        article.setSubtitle(subtitle);
        article.setSummary(summary);
        article.setMetaTitle(metatitle);
        article.setMetaDescription(metadescription);
        article.setAddedDate(date);
        article.setContent(content);

        //Fetch newsletter by id
        Newsletter nl=newsletterRepository.findByNewsletterId(nwletterId);
        article.setNewsletter(nl);
        article.setStatus(status);


        articleRepository.save(article);
        //Newsletter nwletter = newsletterRepository.findByYearAndQuarter(year,quarter);
        List<Article> articles=articleRepository.getArticlesByNewsletter_NewsletterId(nl.getNewsletterId());
        model.addAttribute("articles",articles);
        //Make the entire thing single page
        return "newsletterhome";

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
