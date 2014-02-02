<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
<script type="text/javascript">
//
// Called when the JSONP data is loaded.
//
function comments(data)
{
   //
   // Populate the HTML-table with previous comments.
   //
   id = 1
   $('#ecomments tr').remove();

   $.each(data,function( key,val) {

     $('#ecomments').append("<tr><td>#" + id + " " + val["time"] + "</td><td>" + val["author"] + "</td></tr>" );
    $('#ecomments').append("<tr><td colspan=\"2\"><blockquote>" + val["body"] + "</blockquote></td></tr>" );
    id += 1;
   });

}

function loadComments()
{
    //
    // Make the request, even cross-domain.
    //
    $.ajax({
        url:"http://comments.tweaked.io/comments/<!-- tmpl_var name='comments' -->?callback=?",
        dataType:'jsonp',
        crossDomain:true,
    });
}

$( document ).ready(function() {

    //
    // Load existing comments.
    //
    loadComments();

    //
    // Show the comment area.
    $("#comdiv").toggle();

    //
    // Capture form-submissions.
    //
    $("#myform").submit(function() {

    $.ajax({
           type: "POST",
           url: "http://comments.tweaked.io/comments/",
           data: $("#myform").serialize(), // serializes the form's elements.
           error: function(r,e)
           {
               loadComments();
           },
           complete: function(r,e)
           {
               loadComments();
           },
           datatype: 'jsonp',
         })
         return false;
    });
});
</script>
