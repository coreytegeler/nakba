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

echo '<div class="body-text">';
	echo '<div class="body-inner">';
		echo '<div class="row align-items-center flex-column">';
			echo '<div class="col col-12 col-sm-8">';
				echo '<div class="blocks">';
					echo $post->post_content;
				echo '</div>';
			echo '</div>';
		echo '</div>';
	echo '</div>';
echo '</div>';

get_footer();
?>