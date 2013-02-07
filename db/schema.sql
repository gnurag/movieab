-- phpMyAdmin SQL Dump
-- version 3.1.2deb1ubuntu0.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 10, 2011 at 01:46 AM
-- Server version: 5.0.75
-- PHP Version: 5.2.6-3ubuntu4.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `movieab`
--

-- --------------------------------------------------------

--
-- Table structure for table `acts_as_xapian_jobs`
--

DROP TABLE IF EXISTS `acts_as_xapian_jobs`;
CREATE TABLE IF NOT EXISTS `acts_as_xapian_jobs` (
  `id` int(11) NOT NULL auto_increment,
  `model` varchar(255) NOT NULL,
  `model_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_acts_as_xapian_jobs_on_model_and_model_id` (`model`,`model_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=121 ;

-- --------------------------------------------------------

--
-- Table structure for table `amazon_editorial_reviews`
--

DROP TABLE IF EXISTS `amazon_editorial_reviews`;
CREATE TABLE IF NOT EXISTS `amazon_editorial_reviews` (
  `id` int(11) NOT NULL auto_increment,
  `title_id` int(11) NOT NULL,
  `source` varchar(64) default NULL,
  `content` text,
  `supressed` tinyint(1) default NULL,
  `disabled` tinyint(1) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `amazon_images`
--

DROP TABLE IF EXISTS `amazon_images`;
CREATE TABLE IF NOT EXISTS `amazon_images` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title_id` int(11) NOT NULL,
  `swatch` varchar(100) default NULL,
  `swatch_height` smallint(6) default NULL,
  `swatch_width` smallint(6) default NULL,
  `small` varchar(100) default NULL,
  `small_height` smallint(6) default NULL,
  `small_width` smallint(6) default NULL,
  `thumbnail` varchar(100) default NULL,
  `thumbnail_height` smallint(6) default NULL,
  `thumbnail_width` smallint(6) default NULL,
  `tiny` varchar(100) default NULL,
  `tiny_height` smallint(6) default NULL,
  `tiny_width` smallint(6) default NULL,
  `medium` varchar(100) default NULL,
  `medium_height` smallint(6) default NULL,
  `medium_width` smallint(6) default NULL,
  `large` varchar(100) default NULL,
  `large_height` smallint(6) default NULL,
  `large_width` smallint(6) default NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Table structure for table `amazon_items`
--

DROP TABLE IF EXISTS `amazon_items`;
CREATE TABLE IF NOT EXISTS `amazon_items` (
  `id` int(11) NOT NULL auto_increment,
  `title_id` int(11) NOT NULL,
  `asin` varchar(20) default NULL,
  `ean` varchar(20) default NULL,
  `isbn` varchar(20) default NULL,
  `upc` varchar(15) default NULL,
  `detail_page` text,
  `sales_rank` int(11) default NULL,
  `aspect_ratio` varchar(12) default NULL,
  `audience_rating` varchar(32) default NULL,
  `binding` varchar(12) default NULL,
  `dvd_layers` tinyint(4) default NULL,
  `dvd_sides` tinyint(4) default NULL,
  `label` varchar(32) default NULL,
  `manufacturer` varchar(32) default NULL,
  `orig_release` date default NULL,
  `release_date` date default NULL,
  `theatre_release` date default NULL,
  `picture_format` varchar(20) default NULL,
  `publisher` varchar(32) default NULL,
  `region_code` tinyint(4) default NULL,
  `running_time` smallint(6) default NULL,
  `studio` varchar(32) default NULL,
  `title_name` varchar(128) default NULL,
  `deleted` tinyint(1) default NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `title_id` (`title_id`),
  KEY `asin` (`asin`),
  KEY `upc` (`upc`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Table structure for table `awards`
--

DROP TABLE IF EXISTS `awards`;
CREATE TABLE IF NOT EXISTS `awards` (
  `id` smallint(4) NOT NULL auto_increment,
  `scheme` varchar(256) NOT NULL,
  `name` varchar(100) default NULL,
  `description` text,
  `disabled` tinyint(1) default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `scheme` (`scheme`),
  KEY `name` (`name`),
  KEY `disabled` (`disabled`),
  KEY `created_at` (`created_at`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- Table structure for table `award_nominations`
--

DROP TABLE IF EXISTS `award_nominations`;
CREATE TABLE IF NOT EXISTS `award_nominations` (
  `id` int(11) NOT NULL auto_increment,
  `title_id` int(11) NOT NULL,
  `award_id` smallint(4) NOT NULL,
  `person_id` int(11) default NULL,
  `year` smallint(4) default NULL,
  `label` varchar(256) NOT NULL,
  `term` varchar(256) NOT NULL,
  `award_type` varchar(20) NOT NULL,
  `disabled` tinyint(1) default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `movie_id` (`title_id`),
  KEY `year` (`year`),
  KEY `disabled` (`disabled`),
  KEY `created_at` (`created_at`),
  KEY `award_type` (`award_type`),
  FULLTEXT KEY `label` (`label`),
  FULLTEXT KEY `term` (`term`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13058 ;

-- --------------------------------------------------------

--
-- Table structure for table `freebase_facts`
--

DROP TABLE IF EXISTS `freebase_facts`;
CREATE TABLE IF NOT EXISTS `freebase_facts` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title_id` int(11) NOT NULL,
  `freebase_id` varchar(42) NOT NULL,
  `initial_release_date` date default NULL,
  `music` varchar(100) default NULL,
  `language` varchar(20) default NULL,
  `rating` tinyint(4) default NULL,
  `estimated_budget` int(11) default NULL,
  `country` varchar(20) default NULL,
  `runtime` smallint(6) default NULL,
  `film_collections` int(11) default NULL,
  `soundtrack` varchar(300) default NULL,
  `genre` varchar(42) default NULL,
  `film_format` varchar(42) default NULL,
  `tagline` varchar(100) default NULL,
  `disabled` tinyint(1) NOT NULL default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `freebase_id` (`freebase_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COMMENT='Store film/film facts from freebase data dump' AUTO_INCREMENT=7160 ;

-- --------------------------------------------------------

--
-- Table structure for table `generes`
--

DROP TABLE IF EXISTS `generes`;
CREATE TABLE IF NOT EXISTS `generes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL,
  `genere_type` varchar(32) default NULL,
  `disabled` tinyint(1) default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `genere_type` (`genere_type`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=525 ;

-- --------------------------------------------------------

--
-- Table structure for table `google_images`
--

DROP TABLE IF EXISTS `google_images`;
CREATE TABLE IF NOT EXISTS `google_images` (
  `id` int(11) NOT NULL auto_increment,
  `resource_type` varchar(10) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `gsearch_result_class` varchar(20) default NULL,
  `title` varchar(100) default NULL,
  `title_no_formatting` varchar(100) default NULL,
  `content` varchar(100) default NULL,
  `content_no_formatting` varchar(100) default NULL,
  `image_id` varchar(32) default NULL,
  `width` mediumint(9) default NULL,
  `height` mediumint(9) default NULL,
  `tb_width` smallint(6) default NULL,
  `tb_height` smallint(6) default NULL,
  `unescaped_url` varchar(300) NOT NULL,
  `visible_url` varchar(300) NOT NULL,
  `url` varchar(300) NOT NULL,
  `tb_url` varchar(300) NOT NULL,
  `original_context_url` varchar(300) default NULL,
  `disabled` tinyint(1) default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `resource_type` (`resource_type`,`resource_id`),
  KEY `disabled` (`disabled`),
  KEY `created_at` (`created_at`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=537057 ;

-- --------------------------------------------------------

--
-- Table structure for table `nytimes_reviews`
--

DROP TABLE IF EXISTS `nytimes_reviews`;
CREATE TABLE IF NOT EXISTS `nytimes_reviews` (
  `id` int(11) NOT NULL auto_increment,
  `title_id` int(11) NOT NULL,
  `nyt_movie_id` varchar(24) NOT NULL,
  `display_title` varchar(256) NOT NULL,
  `sort_name` varchar(256) default NULL,
  `mpaa_rating` varchar(6) default NULL,
  `critics_pick` tinyint(1) default '0',
  `thousand_best` tinyint(1) default '0',
  `byline` varchar(100) default NULL,
  `headline` text,
  `capsule_review` text,
  `summary_short` text,
  `publication_date` date default NULL,
  `opening_date` date default NULL,
  `dvd_release_date` date default NULL,
  `date_updated` datetime default NULL,
  `seo_name` varchar(256) default NULL,
  `article_url` varchar(256) default NULL,
  `overview_url` varchar(256) default NULL,
  `showtimes_url` varchar(256) default NULL,
  `awards_url` varchar(256) default NULL,
  `community_url` varchar(256) default NULL,
  `trailers_url` varchar(256) default NULL,
  `thumbnail` varchar(256) default NULL,
  `nyt_synced` tinyint(1) default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `title_id` (`title_id`),
  KEY `nyt_movie_id` (`nyt_movie_id`),
  KEY `display_title` (`display_title`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9164 ;

-- --------------------------------------------------------

--
-- Table structure for table `people`
--

DROP TABLE IF EXISTS `people`;
CREATE TABLE IF NOT EXISTS `people` (
  `id` int(11) NOT NULL auto_increment,
  `netflix_id` varchar(120) NOT NULL,
  `nfid` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `role` varchar(32) NOT NULL,
  `bio` text,
  `website_url` varchar(256) default NULL,
  `nf_synced` tinyint(1) default NULL,
  `gi_synced` tinyint(1) default '0',
  `disabled` tinyint(1) NOT NULL default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `netflix_id` (`netflix_id`),
  KEY `nfid` (`nfid`),
  KEY `name` (`name`),
  KEY `type` (`role`),
  KEY `disabled` (`disabled`),
  FULLTEXT KEY `bio` (`bio`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=162328 ;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` int(11) NOT NULL auto_increment,
  `title_id` int(11) NOT NULL,
  `subject` varchar(128) default NULL,
  `review` text,
  `published` tinyint(1) default '1',
  `disabled` tinyint(1) default '0',
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `resource_type` (`title_id`),
  KEY `published` (`published`),
  KEY `disabled` (`disabled`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=26 ;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(64) NOT NULL,
  `description` varchar(256) default NULL,
  `disabled` tinyint(1) default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` int(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `stashes`
--

DROP TABLE IF EXISTS `stashes`;
CREATE TABLE IF NOT EXISTS `stashes` (
  `id` int(11) NOT NULL auto_increment,
  `title_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `stash_type_id` int(11) default NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `title_id` (`title_id`),
  KEY `user_id` (`user_id`),
  KEY `stash_type_id` (`stash_type_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Table structure for table `titles`
--

DROP TABLE IF EXISTS `titles`;
CREATE TABLE IF NOT EXISTS `titles` (
  `id` int(11) NOT NULL auto_increment,
  `netflix_id` varchar(120) NOT NULL,
  `nfid` int(11) NOT NULL,
  `title_type` varchar(20) default 'movie',
  `title` varchar(256) NOT NULL,
  `title_short` varchar(256) default NULL,
  `synopsis` text,
  `release_year` smallint(4) default NULL,
  `runtime` mediumint(9) default NULL,
  `mpaa_rating` varchar(6) default NULL,
  `netflix_rating` float default NULL,
  `main_genere` varchar(42) default NULL,
  `website_url` varchar(256) default NULL,
  `alternate_website_url` varchar(256) default NULL,
  `supplier_id` smallint(4) NOT NULL,
  `creator_id` smallint(4) default NULL,
  `box_art_small` varchar(392) default NULL,
  `box_art_medium` varchar(392) default NULL,
  `box_art_large` varchar(392) default NULL,
  `nf_created` datetime default NULL,
  `nf_updated` datetime default NULL,
  `nf_published` datetime default NULL,
  `title_format_id` tinyint(4) default NULL,
  `audio_format_id` tinyint(4) default NULL,
  `language_id` tinyint(4) default NULL,
  `nf_synced` tinyint(1) default '0',
  `nyt_synced` tinyint(1) default '0',
  `gi_synced` tinyint(1) default '0',
  `gv_synced` tinyint(1) default '0',
  `amzn_synced` tinyint(1) NOT NULL default '0',
  `disabled` tinyint(1) NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `netflix_id` (`netflix_id`),
  KEY `release_year` (`release_year`),
  KEY `mpaa_rating` (`mpaa_rating`),
  KEY `netflix_rating` (`netflix_rating`),
  KEY `language_id` (`language_id`),
  KEY `created_at` (`created_at`),
  KEY `updated_at` (`updated_at`),
  KEY `nf_created` (`nf_created`),
  KEY `nf_updated` (`nf_updated`),
  KEY `disabled` (`disabled`),
  KEY `title` (`title`),
  KEY `nfid` (`nfid`),
  KEY `main_genere` (`main_genere`),
  FULLTEXT KEY `synopsis` (`synopsis`),
  FULLTEXT KEY `title_2` (`title`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=123197 ;

-- --------------------------------------------------------

--
-- Table structure for table `title_casts`
--

DROP TABLE IF EXISTS `title_casts`;
CREATE TABLE IF NOT EXISTS `title_casts` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) NOT NULL,
  `title_id` int(11) NOT NULL,
  `disabled` tinyint(1) default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `person_id` (`person_id`),
  KEY `title_id` (`title_id`),
  KEY `disabled` (`disabled`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=585427 ;

-- --------------------------------------------------------

--
-- Table structure for table `title_generes`
--

DROP TABLE IF EXISTS `title_generes`;
CREATE TABLE IF NOT EXISTS `title_generes` (
  `id` int(11) NOT NULL auto_increment,
  `title_id` int(11) NOT NULL,
  `genere_id` int(11) NOT NULL,
  `disabled` tinyint(1) default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `title_id` (`title_id`),
  KEY `genere_id` (`genere_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=552581 ;

-- --------------------------------------------------------

--
-- Table structure for table `title_upc`
--

DROP TABLE IF EXISTS `title_upc`;
CREATE TABLE IF NOT EXISTS `title_upc` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title_id` int(10) unsigned NOT NULL,
  `upc` varchar(15) NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `title_id` (`title_id`),
  KEY `upc` (`upc`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12658 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) NOT NULL default '',
  `fullname` varchar(128) default NULL,
  `location` varchar(128) default NULL,
  `website` varchar(255) default NULL,
  `encrypted_password` varchar(128) NOT NULL default '',
  `password_salt` varchar(255) NOT NULL default '',
  `reset_password_token` varchar(255) default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_created_at` datetime default NULL,
  `sign_in_count` int(11) default '0',
  `current_sign_in_at` datetime default NULL,
  `last_sign_in_at` datetime default NULL,
  `current_sign_in_ip` varchar(255) default NULL,
  `last_sign_in_ip` varchar(255) default NULL,
  `confirmation_token` varchar(255) default NULL,
  `confirmed_at` datetime default NULL,
  `confirmation_sent_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  KEY `name` (`fullname`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE IF NOT EXISTS `user_roles` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `disabled` tinyint(1) default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`,`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
