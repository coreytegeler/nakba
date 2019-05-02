<?php
// if( isset( $curr_chapter ) ) {
// 	$chapter = $curr_chapter;
// } else {
// 	$chapter = $post;
// }
$chapter = $post;
echo '<main class="loaded" data-id="'.$chapter->ID.'" data-url="'.get_the_permalink( $chapter ).'">';
if( have_rows( 'intro' ) ) {
	echo '<div id="intro" class="body-text" style="background-image:url(' . get_field( 'intro_image' ) . ')">';
		echo '<div class="body-inner">';
			echo '<div class="row align-items-center flex-column">';
				echo '<div class="col col-12 col-sm-8">';
					echo '<h4>'.$chapter->post_title.'</h4>';
					echo '<div class="tabs">';
						while( have_rows( 'intro' ) ) {
							the_row();
							$i = get_row_index();
							echo '<div class="tab '.($i==1?'active':'').'" data-id="intro-'.$i.'">';
								echo '<h4>'.get_sub_field( 'title' ).'</h4>';
							echo '</div>';
						}
					echo '</div>';
					echo '<div class="tab-contents">';
						while( have_rows( 'intro' ) ) {
							the_row();
							$i = get_row_index();
							echo '<div class="intro-body tab-content '.($i==1?'active':'').'" data-id="intro-'.$i.'">';
								// echo get_body_excerpt( get_sub_field( 'body' ) );

								echo '<div class="expand-wrapper">';
									echo '<div class="body-excerpt">'.get_sub_field( 'top_body' ).'</div>';
									echo '<div class="body-after-excerpt expand-content"><div class="expand-inner">'.get_sub_field( 'bottom_body' ).'</div></div>';
									echo '<div class="expand-toggle cond">';
										echo '<span class="more">'.pll__( 'Read More' ).'</span>';
										echo '<span class="less">'.pll__( 'Read Less' ).'</span>';
									echo '</div>';
								echo '</div>';


							echo '</div>';
						}
					echo '</div>';
				echo '</div>';
			echo '</div>';
		echo '</div>';
	echo '</div>';
}
echo '<div class="blocks">';
	echo '<div class="blocks-inner">';
		echo $chapter->post_content;
	echo '</div>';


	$tweet_link = 'https://twitter.com/intent/tweet?&text=';
	$tweet_text = urlencode( get_field( 'tweet_text' ) );

	echo '<a href="' . $tweet_link.$tweet_text . '" target="_blank" id="take-action" title="' . pll__( 'Take Action' ) . '">';
		echo '<h3>' . pll__( 'Take Action' ) . '</h3>';
	echo '</a>';

echo '</div>';



include '_archive.php';

echo '<div id="lightbox" class="overlay">';
	echo '<div class="lightbox-close icon-close" style="background-image:url('.get_template_directory_uri().'/assets/imgs/close.svg)"></div>';
	echo '<div id="lightbox-media">';
	echo '</div>';
echo '</div>';
echo '</main>';
?>