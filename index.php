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

$chapters_query = new WP_Query( array(
	'post_type' => 'chapters',
	'posts_per_page' => -1,
	'post_status' => array('publish', 'draft' ),
	'order' => 'ASC',
	'orderby' => 'date',
) );

echo '<div id="cover">';
	
	echo '<div id="cover-media">';
		echo '<div class="media video">';
			echo '<video autoplay loop muted>';
				echo '<source src="https://nakba.amnesty.org/wp-content/uploads/2018/05/croppedSmoke_3.mp4" type="video/mp4">';
			echo '</video>';
		echo '</div>';	
		if( $chapters_query->have_posts() ) {
			while( $chapters_query->have_posts() ) {
				$chapters_query->the_post();
				if( has_post_thumbnail() ) {
					echo '<div class="media image" style="background-image:url('.get_the_post_thumbnail_url().');" data-slug="'.$post->post_name.'"></div>';
				}
			}
		}
	echo '</div>';

	echo '<div id="cover-overlay" class="align-items-center">';
		echo '<div class="row">';
			echo '<div class="col col-sm-12 col-md-6 col-lg-4">';
				echo '<div class="align-items-center h-100">';
					echo '<div class="cover-title">';
						echo '<h1 class="cover-title-row ar">سبعون</h1>';
						echo '<h1 class="cover-title-row en">Seventy</h1>';
						echo '<h1 class="cover-title-row ar">عاما من</h1>';
						echo '<h1 class="cover-title-row en">Years of</h1>';
						echo '<h1 class="cover-title-row ar">الاختناق</h1>';
						echo '<h1 class="cover-title-row en">Suffocation</h1>';
						echo '<div class="cover-sub-title">';
							echo '<h4>'.get_bloginfo( 'description' ).'</h4>';
						echo '</div>';
						echo '<a href="https://amnesty.org" class="amnesty-logo">';
							echo '<img src="'.get_template_directory_uri().'/assets/imgs/amnesty.png">';
						echo '</a>';
					echo '</div>';
				echo '</div>';
			echo '</div>';
			echo '<div class="col col-sm-12 col-md-6 col-lg-8">';
				echo '<div class="align-items-center h-100">';
					echo '<div class="chapter-squares">';
						if( $chapters_query->have_posts() ) {
							while( $chapters_query->have_posts() ) {
								$chapters_query->the_post();
								echo '<a class="chapter-square '.$post->post_status.'" href="'.get_the_permalink().'" data-slug="'.$post->post_name.'">';
									echo '<h3>'.$post->post_title.'</h3>';
								echo '</a>';
							}
							wp_reset_postdata();
						}
					echo '</div>';
				echo '</div>';
			echo '</div>';
		echo '</div>';
	echo '</div>';

echo '</div>';

// echo '<div class="blocks">';
	// $chapters_query = new WP_Query( array(
	// 	'post_type' => 'chapters',
	// 	'posts_per_page' => -1,
	// 	'order' => 'ASC',
	// 	'orderby' => 'date',
	// ) );
	// if( $chapters_query->have_posts() ):
	// 	while( $chapters_query->have_posts() ):
	// 		$chapters_query->the_post();
	// 	endwhile;
	// 	wp_reset_postdata();
	// endif;	
// echo '</div>';

get_footer();
?>