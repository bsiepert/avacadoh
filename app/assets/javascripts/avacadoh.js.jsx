/**
 * @jsx React.DOM
 */

var AvacadohUser = Backbone.Model.extend({urlRoot: '/avacadoh/players'});
var UserForm = React.createClass({
    handleSubmit: function(e) {
        e.preventDefault();
        var first_name = React.findDOMNode(this.refs.first_name).value.trim();
        var last_name = React.findDOMNode(this.refs.last_name).value.trim();
        var email_address = React.findDOMNode(this.refs.email_address).value.trim();
        if (!first_name || !last_name) {
            return;
        }

        // backbone instance create and save here

        var user = new AvacadohUser({first_name: first_name, last_name: last_name, email_address: email_address});
        user.save();

        React.findDOMNode(this.refs.first_name).value = '';
        React.findDOMNode(this.refs.last_name).value = '';
        React.findDOMNode(this.refs.email_address).value = '';
    },
    render: function() {
        return (
            <form className="userForm" onSubmit={this.handleSubmit}>
                <input type="text" placeholder="Fist name" ref="first_name" />
                <input type="text" placeholder="Last name..." ref="last_name" />
                <input type="text" placeholder="Email_address..." ref="email_address" />
                <input type="submit" value="Post" />
            </form>
        );
    }
});



$(document).ready( function() {

    React.render(
        <UserForm url="/avacadoh/users"  />,
        document.getElementById('avacadoh_div')
    );
});

