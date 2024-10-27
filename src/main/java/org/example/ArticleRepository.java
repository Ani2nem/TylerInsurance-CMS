package org.example;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ArticleRepository extends JpaRepository<Article, Long> {
    @Query("SELECT a FROM Article a WHERE a.newsletter.year = :year AND a.newsletter.quarter = :quarter ORDER BY a.addedDate DESC")
    List<Article> findByNewsletterYearAndQuarter(
            @Param("year") Integer year,
            @Param("quarter") Integer quarter
    );
}