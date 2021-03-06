<?php
$lang = pll_current_language();
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
			echo '<div class="cover-map desktop" style="background-image:url('. get_field( 'bg_map', 'option' ) .')"></div>';

			$bg_video = get_field( 'bg_video', 'option' );
			echo '<img src="'.$bg_video.'" alt="Smoke over black background"/>';

			// echo '<video autoplay loop muted>';
			// 	echo '<source src="' . get_field( 'bg_video', 'option' ) . '" type="video/mp4">';
			// echo '</video>';
		echo '</div>';	
		if( $chapters_query->have_posts() ) {
			while( $chapters_query->have_posts() ) {
				$chapters_query->the_post();
				if( has_post_thumbnail() ) {
					echo '<div class="media image desktop" style="background-image:url('.get_the_post_thumbnail_url().');" data-id="'.$post->ID.'"></div>';
				}
			}
		}
	echo '</div>';

	echo '<div id="cover-overlay" class="align-items-center">';
		echo '<div class="row">';
			echo '<div class="left col col-12 col-sm-5">';
				echo '<div class="cover-content">';
					echo '<div class="align-items-center">';
						echo '<div class="cover-title">';
							echo '<h2 class="cover-title-row ar">+سبعون</h2>';
							echo '<h2 class="cover-title-row en">Seventy+</h2>';
							echo '<h2 class="cover-title-row ar">عاما من</h2>';
							echo '<h2 class="cover-title-row en">Years of</h2>';
							echo '<h2 class="cover-title-row ar">الاختناق</h2>';
							echo '<h2 class="cover-title-row en">Suffocation</h2>';
							echo '<div class="cover-sub-title">';
								echo '<h5>'.get_bloginfo( 'description' ).'</h5>';
							echo '</div>';
						echo '</div>';
					echo '</div>';
					echo '<div class="amnesty-logo desktop">';
						echo '<a href="https://amnesty.org/'.$lang.'" target="_blank" class="'.$lang.'">';
							echo '<img src="'.get_field( $lang.'_logo', 'options' ).'" alt="Amnesty International logo">';
						echo '</a>';
					echo '</div>';
				echo '</div>';
			echo '</div>';
			echo '<div class="right col col-12 col-sm-7">';
				echo '<div class="align-items-center">';
					echo '<div class="chapter-squares">';
						echo '<div class="cover-map mobile" style="background-image:url('. get_field( 'bg_map', 'option' ) .')"></div>';
						if( $chapters_query->have_posts() ) {
							while( $chapters_query->have_posts() ) {
								$chapters_query->the_post();
								if( $post->post_status == 'publish' ) {
									echo '<a class="chapter-square" href="'.get_the_permalink().'" data-title="'.$post->post_title.'" data-id="'.$post->ID.'">';
										echo '<h4 class="'.$lang.'">'.$post->post_title.'</h4>';
									echo '</a>';
								} else {
									echo '<a class="chapter-square disabled"><h4 class="'.$lang.'">'.$post->post_title.'</br>'.pll__( 'Coming Soon' ).'</h4></a>';
								}
							}
							wp_reset_postdata();
						}
					echo '</div>';
					echo '<div class="amnesty-logo mobile">';
						echo '<a href="https://amnesty.org/'.$lang.'" target="_blank" class="'.$lang.'">';
							echo '<img src="'.get_field( $lang.'_logo', 'options' ).'">';
						echo '</a>';
					echo '</div>';
				echo '</div>';
			echo '</div>';
		echo '</div>';
	echo '</div>';
echo '</div>';
?>