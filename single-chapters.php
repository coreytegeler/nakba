<?php
get_header();
if( have_rows( 'intro' ) ) {
	echo '<div id="intro">';
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
}
echo '<div class="blocks">';
	echo $post->post_content;
echo '</div>';
echo '<div id="archival-materials">';
	echo '<a href="#" class="archival-toggle"><h4>Archival Materials</h4></a>';
	$archival_material = get_field( 'archival_material' );
	if( $archival_material ) {
		echo '<div class="objects row">';
			foreach( $archival_material as $object ) {
				echo '<div class="col col-12 col-sm-6 col-md-4 object '.$object['type'].'">';
					switch( $object['type'] ) {
						case 'image':
							echo '<img src="'.$object['sizes']['large'].'"/>';
							break;
						case 'video':
							echo '<video src="'.$object['url'].'" controls/>';
							break;
					}
				echo '</div>';
			}
		echo '</div>';
	}
echo '</div>';
?>
</div>
<?php get_footer(); ?>