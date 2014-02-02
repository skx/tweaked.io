//
//
//
function loadComments(url)
{

    $.ajax({
        url: url + "?callback=?",
        dataType:'jsonp',
        crossDomain:true,
	complete: (function(){populateReplyForm(url);})
    });
}


//
// Called when the JSONP data is loaded.
//
function comments(data)
{
   //
   // Populate the HTML-table with previous comments.
   //
   id = 1
    $("#comments").html( "<table></table>");

    $.each(data,function( key,val) {

	$('#comments').append("<tr><td><p>#" + id + "&nbsp;&nbsp;" + val["ago"] + "</p></td><td><p>&nbsp;&nbsp;" + val["author"] + "</p></td></tr>" );
	$('#comments').append("<tr><td colspan=\"2\"><blockquote><p>" + val["body"] + "</p></blockquote></td></tr>" );
	id += 1;
    });
}


//
// Generate the reply-form for users to add comments.
//
function populateReplyForm( url )
{

    //
    //  Once the comments are loaded we can populate the reply-function
    //
    $("#comments").append("<div id=\"comments-reply\"></div>" );

    //
    //  This is unpleasant.
    //
    $("#comments-reply").html(" \
  <h2>Add Comment</h2> \
  <blockquote> \
<form method=\"POST\" id=\"myform\" action=\"\"> \
      <table> \
        <tr> \
          <td>Your Name</td> \
          <td><input type=\"text\" name=\"author\" /></td> \
        </tr> \
        <tr> \
          <td colspan=\"2\"><textarea name=\"body\" rows=\"5\" cols=\"50\"></textarea></td> \
        </tr> \
        <tr> \
          <td></td> \
          <td align=\"right\"><input type=\"submit\" value=\"Add Comment\"/></td> \
        </tr> \
      </table> \
    </form> \
  </blockquote> \
");

    //
    // Capture form-submissions.
    //
    $("#myform").bind( "submit",(function() {
	$("#myform").hide();
	$.ajax({
            type: "POST",
            url: url,
            data: $("#myform").serialize(), // serializes the form's elements.
            error: function(r,e)
            {
		loadComments( url);
            },
            complete: function(r,e)
            {
		loadComments( url );
            },
            datatype: 'jsonp',
        })
        return false;
    }));

}

//
// Entry point.
//
// Assumes the URL specified can be used to GET/POST comments.
//
function discussion(  url )
{
    //
    //  Load the comments, and populate the <div id="comments"> area with them
    //
    loadComments( url )

}

