<?php
if( !wp_doing_ajax() ) {
	get_header();
}
if( have_rows( 'intro' ) ) {
	echo '<div id="intro" class="body-text" style="background-image:url(' . get_field( 'intro_image' ) . ')">';
		echo '<div class="body-inner">';
			echo '<div class="row align-items-center flex-column">';
				echo '<div class="col col-12 col-sm-8">';
					echo '<h3>'.$post->post_title.'</h3>';
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
		echo $post->post_content;
	echo '</div>';
echo '</div>';
echo '<div id="archive" class="overlay">';
	echo '<a href="#" class="archive-toggle"><h4>' . pll__( 'Archival Materials' ) . '</h4></a>';
	$archival_material = get_field( 'archival_material' );
	if( $archival_material ) {
		echo '<div class="archive-medias row">';
			foreach( $archival_material as $media ) {
				echo '<div class="col col-12 col-sm-6 col-md-4 archive-media '.$media['type'].'">';
					switch( $media['type'] ) {
						case 'image':
							echo '<img src="'.$media['sizes']['large'].'"/>';
							break;
						case 'video':
							echo '<video src="'.$media['url'].'" controls></video>';
							break;
					}
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

if( !wp_doing_ajax() ) {
	get_footer();
}
?>
