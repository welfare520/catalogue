$(function() {
  $( "#campaign-edit-save" ).click( function(e){
  	e.preventDefault();
  	var form = document.getElementById("campaign-edit-form");
  	var campaignId = document.getElementById("id-span").innerHTML.toString();

  	$.post('/campaign/'+campaignId+'/save', {
        "id": campaignId,
        "name": form.elements.namedItem("name").value.toString(),
        "company": form.elements.namedItem("company").value.toString(),
        "owner": form.elements.namedItem("owner").value.toString(),
        "url": form.elements.namedItem("affiliate-url").value.toString()
    }, function(response){ 
       location.reload();
    });

  });
});

$(function() {
    $( ".edit-campaign-button" ).click(function(e) {
      e.preventDefault();
        var campaignId = this.name.toString();

        var form = document.getElementById("campaign-edit-form");
        document.getElementById("id-span").innerHTML=campaignId;
        

        $.ajax({
	        type: "GET",
	        contentType: false, 
	        timeout: 50000,
	        cache:false,
	        processData: false,
	        dataType: 'json', 
	        url: '/campaign/'+campaignId,
	        success: function (data) { 
	        	form.elements.namedItem("name").value = data.name;
	        	form.elements.namedItem("company").value = data.company;
	        	form.elements.namedItem("owner").value = data.owner;
	        	form.elements.namedItem("affiliate-url").value = data.url;
	        },
	      error: function (xhr, ajaxOptions, thrownError) {
	        alert(xhr.status);
	        alert(thrownError);
	      }
	    });

    });
});

$(function() {
  $( "#start" ).datepicker({inline: true});
  $( "#end" ).datepicker({inline: true});
});