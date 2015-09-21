function saveData(thisObj){
  var selectObj = thisObj.value.toString(); 
  var NameObj=document.getElementById("name_"+selectObj);
  var NameENObj=document.getElementById("name_en_"+selectObj);
  var NameESObj=document.getElementById("name_es_"+selectObj);
  var DescObj=document.getElementById("desc_"+selectObj);
  var TypeObj=document.getElementById("type_"+selectObj);
  var IconObj=document.getElementById("icon_"+selectObj);
  var PriceObj = document.getElementById("price_"+selectObj);

  var price = PriceObj.value || 10;

  $.post('/category/'+selectObj+'/update', {
    'name': NameObj.value.toString(),
    'name_en': NameENObj.value.toString(),
    'name_es': NameESObj.value.toString(),
    'description': DescObj.value.toString(),
    'type': TypeObj.value.toString(),
    'price': price
    }, function(response){ 

     });

  $( "#edit-dialog-"+selectObj).dialog( "close" );

}

function deleteId(selectObj){ 
  $.post('/category/'+selectObj+'/update', {
        "status": "deleted"
    }, function(response){ 

    });

  $( "#dialog_delete_"+selectObj).dialog( "close" );
  location.reload(false);
}

function moveId(selectObj){
  var PID=document.getElementById("move2id_"+selectObj).value.toString();

 
  $.post('/category/'+selectObj+'/update', {
        "parent": PID
    }, function(response){ 

    });

  $( "#dialog_move_"+selectObj).dialog( "close" );
  location.reload(false);
}

function addCategory(selectObj){
    var nameChild=document.getElementById("addsub_"+selectObj).value.toString();
    $.post('/category/'+selectObj+'/addchild', {
            "id": selectObj,
            "name": nameChild
        }, function(response){ 

    });

    $( "#dialog_add_"+selectObj).dialog( "close" );
    location.reload(false);
}

function updateIcon(id) {
    id = id.toString();
    var test = "icon_"+id
    var icon = document.getElementById("icon_"+id).files[0];

    var fd = new FormData();
    fd.append('data', icon);

    $.ajax({
        type: "POST",
        contentType: false, 
        timeout: 50000,
        cache:false,
        processData: false,
        url: '/upload/'+id+'/icon',
        data: fd,
        success: function (data) {            
            d = new Date();
            $("#img_"+id).attr("src", "/icon/" + id + ".jpg?"+new Date().getTime());
            window.alert("Icon Uploaded");
            return true; 
        },
      error: function (xhr, ajaxOptions, thrownError) {
        alert(xhr.status);
        alert(thrownError);
      }
    });
}


// function for edit button 
$( function() {

    $( ".edit-dialog").dialog({
      width: 1000,
      height: 600,
      autoOpen: false,
      modal: true,
      show: {
        effect: "blind",
        duration: 200
      },
      hide: {
        effect: "explode",
        duration: 200
      }
    });
 
    $( '.edit-category' ).click(function() {
            var Id = this.value.toString()
            $( "#edit-dialog-" + Id).dialog( "open" );                                      
    });
});


// function for move button 
$(function() {
    $( ".move-dialog" ).dialog({
      width: 600,
      height: 300,
      autoOpen: false,
      modal: true,
      show: {
        effect: "blind",
        duration: 200
      },
      hide: {
        effect: "explode",
        duration: 200
      }
    });
 
    $( ".move-category" ).click(function() {
        var Id = this.value.toString()
        $( "#move-dialog-"+Id ).dialog( "open" );
    });
});


// function for delete button 
$(function() {  
    $( ".delete-dialog" ).dialog({
      width: 300,
      height: 200,
      autoOpen: false,
      modal: true,
      show: {
        effect: "blind",
        duration: 200
      },
      hide: {
        effect: "explode",
        duration: 200
      }
    });                              
    $( ".delete-category" ).click(function() {
        var Id = this.value.toString()
        $( "#delete-dialog-"+Id ).dialog( "open" );
    });
});


// function for add button 
$(function() {  
    $( ".add-dialog" ).dialog({
      width: 300,
      height: 200,
      autoOpen: false,
      modal: true,
      show: {
        effect: "blind",
        duration: 200
      },
      hide: {
        effect: "explode",
        duration: 200
      }
    });                              
    $( ".add-category" ).click(function() {
        var Id = this.value.toString()
        $( "#add-dialog-"+Id ).dialog( "open" );
    });
});


$( function() {
    /*
    - how to call the plugin:
    $( selector ).cbpNTAccordion( [options] );
    - destroy:
    $( selector ).cbpNTAccordion( 'destroy' );
    */

    $( '#cbp-ntaccordion' ).cbpNTAccordion();
} );
