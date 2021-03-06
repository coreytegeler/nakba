<div id="archive" class="overlay show-archive">
<?php
	echo '<div class="archive-toggle icon-close" style="background-image:url('.get_template_directory_uri().'/assets/imgs/close.svg)"></div>';
	echo '<div class="archive-title"><h5>' . pll__( 'Archival Materials' ) . '</h5></div>';
	$archival_material = get_field( 'archival_material' );
	if( $archival_material ) {
		echo '<div class="archive-medias row">';
			foreach( $archival_material as $index => $media ) {
				echo '<div class="col col-12 col-sm-6 col-md-4 '.$media['type'].'" id="archive-'.($index+1).'">';
					echo '<a class="block-media archive-media" href="#archive-'.($index+1).'">';

						$alt = $media['alt'] || $media['caption'];

						switch( $media['type'] ) {
							case 'image':
								echo '<img src="'.$media['sizes']['large'].'" alt="'.$alt.'"/>';
								break;
							case 'video':
								if ( $poster = get_field( 'alt_thumb', $media['ID'] ) ) {
									echo '<video src="'.$media['url'].'" nocontrols poster="'.$poster['sizes']['medium_large'].'" alt="'.$alt.'"></video>';
								} else {
									echo '<video src="'.$media['url'].'" nocontrols alt="'.$alt.'"></video>';
								}
								echo '<div class="btn play"></div>';
								break;
							case 'application':
								if ( $thumbnail = get_field( 'alt_thumb', $media['ID'] ) ) {
									echo '<img src="'.$thumbnail['sizes']['medium_large'].'" data-pdf="'.$media['url'].'" alt="'.$alt.'"/>';
								}
								echo '<object data="'.$media['url'].'" type="application/pdf" width="100%" height="100%">';
									echo '<h3>Your browser does not support the PDF. Please <a href="'.$media['url'].'" target="_blank">click here to download</a>.</h3>';
								echo '</object>';
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
?>