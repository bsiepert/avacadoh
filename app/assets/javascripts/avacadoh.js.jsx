/**
 * @jsx React.DOM
 */

var Player = Backbone.Model.extend({urlRoot: '/players'});
var Players = Backbone.Collection.extend({model: Player, url: '/players'});
var PlayerForm = React.createClass({
    handleSubmit: function(e) {
        e.preventDefault();
        var first_name = React.findDOMNode(this.refs.first_name).value.trim();
        var last_name = React.findDOMNode(this.refs.last_name).value.trim();
        var email_address = React.findDOMNode(this.refs.email_address).value.trim();
        if (!first_name || !last_name) {
            return;
        }

        // backbone instance create and save here

        var player = new Player({first_name: first_name, last_name: last_name, email_address: email_address});
        player.save();

        React.findDOMNode(this.refs.first_name).value = '';
        React.findDOMNode(this.refs.last_name).value = '';
        React.findDOMNode(this.refs.email_address).value = '';
    },
    render: function() {
        return (
            <form className="playerForm" onSubmit={this.handleSubmit}>
                <input type="text" placeholder="First name..." ref="first_name" />
                <input type="text" placeholder="Last name..." ref="last_name" />
                <input type="text" placeholder="Email_address..." ref="email_address" />
                <input type="submit" value="Post" />
            </form>
        );
    }
});

var PlayerRow = React.createClass({
   render: function(){
       return (
           <tr><td>{this.props.fname}</td><td>{this.props.lname}</td><td>{this.props.email}</td></tr>
       );
   }
});
var PlayersList = React.createClass({
   render: function() {
       var player_rows = [];
       console.log("players length:"+ this.props.players.length);
       this.props.players.each(function(player){
           player_rows.push(<PlayerRow fname={player.get('first_name')} lname={player.get('last_name')} email={player.get('email_address')} />);
       });

       return (
           <table>
               <thead>
                    <tr>
                        <th>First Name</th><th>Last Name</th><th>Email Address</th>
                    </tr>
                </thead>
               <tbody>{player_rows}</tbody>
           </table>
       );
   }
});
var PlayerRegistration = React.createClass({
   render: function(){
       return(
           <div>
            <PlayerForm />
            <PlayersList players={this.props.players} />
        </div>
       )
   }
});



$(document).ready( function() {
    players = new Players();
    players.fetch();
    console.log("playwers in outside:"+ players.length);
    React.render(
        <PlayerRegistration players ={players}/>,
        document.getElementById('avacadoh_div')
    );
});

