$(function(){
  removed_tags  = [];
	$("#search-btn").on("click", function(e){
		tag = $("#search-box").val();
		$.ajax({
			url: '/search',
			type: 'POST',
			// dataType: 'default: Intelligent Guess (Other values: xml, json, script, or html)',
			data: {tag: tag},
		})
		.done(function(res) {
			console.log(res);
			for (var i = res.length - 1; i >= 0; i--) {
				res[i]
				$("#search-container").append('<div class="col-sm-6 col-md-4 col-lg-3 space-after">\
        <a href="/notes/'+res[i]["id"]+'">\
          <div class="card">\
            <div class="card-body">'+ res[i].content +'</div> \
          </div>\
      </div>');
			}
		})
		.fail(function(err) {
				$("#search-container").append('Not Found');
				console.log(err);
		})
	});
});	

