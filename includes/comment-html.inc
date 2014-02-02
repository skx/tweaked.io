<!-- tmpl_if name='comments' -->
<div style="display:none" id="comdiv">
  <h2>Comments</h2>
  <table id="ecomments">
  </table>

  <div id="comsub">

  <h2>Add Comment</h2>
  <blockquote>
    <form method="POST" id="myform" action="http://localhost:4567">
      <input type="hidden" name="id" value="<!-- tmpl_var name='comments' -->" />
      <table>
        <tr>
          <td>Your Name</td>
          <td><input type="text" name="author" /></td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="body"  rows="5" cols="50"></textarea></td>
        </tr>
        <tr>
          <td></td>
          <td align="right"><input type="submit" value="Add Comment"/></td>
        </tr>
      </table>
    </form>
  </blockquote>
  </div>
</div>
<!-- /tmpl_if -->
