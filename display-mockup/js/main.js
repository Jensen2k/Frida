
$(document).ready(function() {
	var height = $(document).height();
	var width = $(document).width();
	var num = $(".block").length;
	var open = false;

	$(".pages").width(width*num);
	$(".pages").css("left", "-"+width+"px");
	$(".block, .pages, .menu").height(height);
	$(".block, .app").width(width);
	$(".block").each(function(n) {

	});

	$(".menu").on("click", function(e) {
		if(open) {
			$(".pages").animate({
				left: "-"+width+"px"
			});
			$(".menu").animate({
				left: "0px"
			});
		} else {

			$(".pages").animate({
				left: "0px"
			});
			$(".menu").animate({
				left: width-150+"px"
			});
		}

		open = !open;
	});


});