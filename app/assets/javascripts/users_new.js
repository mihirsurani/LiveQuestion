/**
 * Created by JetBrains RubyMine.
 * User: ramanarayana
 * Date: 9/27/11
 * Time: 6:06 PM
 * To change this template use File | Settings | File Templates.
 */
window.onload  = init;

function init() {
    $("#new_user").submit(verifyDetails);
    $(".field").find("input").val("");
 }

var verifyDetails = function()
{
    var pass = $("#user_pwd").val();
    var conf_pass  = $("#conf_pass").val();
    var count = 0;
    var msg = new Array();
    var userid = $("#user_userid").val();

/*    $.ajax({
        url: "/users/"+userid+"/validate",
        success: function(data){
            if(data=="false")
            {
                msg[count] = "User name already exists. Please retype the User name";
                count++;
            }
        }
    }); */

    if(userid.length == 0 || pass.length == 0)
     {
         msg[count] = "User name  or Password cannot be empty.";
         count++;
     }

    if(pass != conf_pass)
    {
        msg[count] = "The Password & ConfirmPassword do not match. Please check and try again.";
        count++;
    }

    if(pass.length < 6)
    {
        msg[count] = "The Password should be at-least 6 characters. Please check and try again.";
        count++;
    }
    var x = $("#user_email").val();
    var atpos=x.indexOf("@");
    var dotpos=x.lastIndexOf(".");

    if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
    {
        msg[count] = "The Email is in incorrect format. Re type the Email address.";
        count++;
    }

      var $errors_box = $(".create_errors");
    if(count != 0)
    {
        $errors_box.show();
        var $heading = $errors_box.find("h2");
    }
    else
    {
        return true;
    }
    if(count == 1)
    {
        $heading.html(count+" error prohibited this user from being saved:");
    }else if(count > 1)
    {
        $heading.html(count+" errors prohibited this user from being saved:");
    }

     var $ul_element = $("#each_error_create");
    $ul_element.empty();
    for(var i=0; i<count;i++)
    {
        var $li_element = $("#ref_ul").find("#ref_li").clone();
        $ul_element.append($li_element);
        $li_element.html(msg[i]);
        $li_element.attr("id",count);
        $li_element.show();
    }
    return false;
};
