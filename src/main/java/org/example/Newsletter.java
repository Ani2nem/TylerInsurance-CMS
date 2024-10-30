package org.example;

import javax.persistence.*;
import java.util.Date;

import java.util.List;

@Entity
@Table(name = "newsletter")
public class Newsletter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "newsletterid")
    private Long newsletterId;

    @Column(nullable = false)
    private String title;

    private String status;
    private Integer year;
    private Integer quarter;

    @Temporal(TemporalType.DATE)
    @Column(name = "publicationdate")
    private Date publicationDate;

    @Column(name = "updatedate", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private Date updatedAt;

    // Getters and Setters
    public Long getNewsletterId() {
        return newsletterId;
    }

    public void setNewsletterId(Long newsletterId) {
        this.newsletterId = newsletterId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public Integer getQuarter() {
        return quarter;
    }

    public void setQuarter(Integer quarter) {
        this.quarter = quarter;
    }

    public Date getPublicationDate() {
        return publicationDate;
    }

    public void setPublicationDate(Date publicationDate) {
        this.publicationDate = publicationDate;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    @OneToMany(mappedBy = "", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Article> articles;

    // Getters and Setters
    public List<Article> getArticles() {
        return articles;
    }

    public void setArticles(List<Article> articles) {
        this.articles = articles;
    }

    @PrePersist
    protected void onCreate() {
        this.publicationDate = new Date(); // Sets to the current date
        this.updatedAt = new Date();       // Sets to the current datetime
    }

    // Automatically update updatedAt on every update
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = new Date();       // Updates to the current datetime
    }

}
