<?php
if( !wp_doing_ajax() ) {
	get_header();
	include '_cover.php';
}
include '_chapter.php';
if( !wp_doing_ajax() ) {
	get_footer();
}
?>
