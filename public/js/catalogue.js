function saveData(selectObj){
  var NameObj=document.getElementById("name_"+selectObj);
  var NameENObj=document.getElementById("name_en_"+selectObj);
  var NameESObj=document.getElementById("name_es_"+selectObj);
  var DescObj=document.getElementById("desc_"+selectObj);
  var TypeObj=document.getElementById("type_"+selectObj);
  var IconObj=document.getElementById("icon_"+selectObj);

 
  $.post('/category/'+selectObj+'/update', {
    'name': NameObj.value.toString(),
    'name_en': NameENObj.value.toString(),
    'name_es': NameESObj.value.toString(),
    'desc': DescObj.value.toString(),
    'type': TypeObj.value.toString()
    }, function(response){ 

     });

  $( "#dialog_edit_"+selectObj).dialog( "close" );

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
        dataType: 'jpg',
        success: function (data) {
            alert('success');
            return false;
        }
    });

    window.alert("Icon Uploaded");
}


$( function() {
    /*
    - how to call the plugin:
    $( selector ).cbpNTAccordion( [options] );
    - destroy:
    $( selector ).cbpNTAccordion( 'destroy' );
    */

    $( '#cbp-ntaccordion' ).cbpNTAccordion();
} );
