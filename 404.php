<?php
/**
 *
 * @link https://codex.wordpress.org/Template_Hierarchy
 *
 * @package WordPress
 * @subpackage Nakba
 * @since 1.0
 * @version 1.0
 */
get_header();
include '_cover.php';
$chapter_query = new WP_Query( array(
	'post_type' => 'chapters',
	'posts_per_page' => 1,
	'post_status' => array('publish', 'draft' ),
	'order' => 'ASC',
	'orderby' => 'date',
) );
if( $chapter_query->have_posts() ) {
	while( $chapter_query->have_posts() ) {
		$chapter_query->the_post();
		include '_chapter.php';
	}
}
get_footer();
?>