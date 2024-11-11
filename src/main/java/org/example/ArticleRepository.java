package org.example;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Repository
@Transactional
public interface ArticleRepository extends JpaRepository<Article, Long> {
    @Transactional(readOnly = true)
    List<Article> getArticlesByNewsletter_NewsletterId(Long newsletterId);
    List<Article> getArticlesByNewsletter_NewsletterIdAndStatus(Long newsletterId, String status);

    //Article findByTitle(String title);
}