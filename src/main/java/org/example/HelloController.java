package org.example;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HelloController {

    @Autowired
    private EditorContentRepository repository;
    @Autowired
    private NewsletterRepository newsletterRepository;

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
    public String addNewsletter(Model model) {
        return "addnewsletter";
    }

    @GetMapping("/addarticle1")
    public String addarticle1(Model model) {
        return "addarticle1";
    }

    @GetMapping("/addarticle2")
    public String addarticle2(Model model) {
        return "addarticle2";
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
