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
					echo '<h3>'.$chapter->post_title.'</h3>';
					echo '<div class="tabs">';
						while( have_rows( 'intro' ) ) {
							the_row();
							$i = get_row_index();
							echo '<div class="tab '.($i==1?'active':'').'" data-id="intro-'.$i.'">';
								echo '<h3>'.get_sub_field('title').'</h3>';
							echo '</div>';
						}
					echo '</div>';
					echo '<div class="tab-contents">';
						while( have_rows( 'intro' ) ) {
							the_row();
							$i = get_row_index();
							echo '<div class="intro-body tab-content '.($i==1?'active':'').'" data-id="intro-'.$i.'">';
								echo get_body_excerpt( get_sub_field('body') );
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
echo '</div>';

echo '<div id="archive" class="overlay">';
	echo '<div class="archive-toggle icon-close" style="background-image:url('.get_template_directory_uri().'/assets/imgs/close.svg)"></div>';
	echo '<div class="archive-toggle archive-title"><h4>' . pll__( 'Archival Materials' ) . '</h4></div>';
	$archival_material = get_field( 'archival_material' );
	if( $archival_material ) {
		echo '<div class="archive-medias row">';
			foreach( $archival_material as $index => $media ) {
				echo '<div class="col col-12 col-sm-6 col-md-4 '.$media['type'].'">';
					echo '<a class="block-media archive-media" href="#archive-'.($index+1).'">';
						switch( $media['type'] ) {
							case 'image':
								echo '<img src="'.$media['sizes']['large'].'"/>';
								break;
							case 'video':
								echo '<video src="'.$media['url'].'" controls></video>';
								break;
						}
					echo '</a>';
					if( $caption = $media['caption'] ) {
						echo '<div class="archive-caption">'.$caption.'</div>';
					}
				echo '</div>';
			}
		echo '</div>';
	}
echo '</div>';

echo '<div id="lightbox" class="overlay">';
	echo '<div class="lightbox-close icon-close" style="background-image:url('.get_template_directory_uri().'/assets/imgs/close.svg)"></div>';
	echo '<div id="lightbox-media">';
echo '</div>';
echo '</main>';
?>