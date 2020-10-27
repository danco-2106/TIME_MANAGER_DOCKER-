<template>
  <div>
    <form class="form-signin">
      <h1>{{ user.email }}</h1>
      <hr>
      <h3>Edit your personal information</h3>
      <p>Email:
        <input v-model="editInputEmail" type="email" class="form-control" :placeholder="user.email">
      </p>
      <p>Username:
        <input v-model="editInputUsername" type="text" class="form-control" :placeholder="user.username">
      </p>
      <button v-on:click="saveUserInfo" class="btn btn-lg btn-primary btn-block" type="button">Save</button>
      <button v-on:click="deleteUser" class="btn btn-lg btn-danger btn-block" type="button">Delete</button>
    </form>
  </div>
</template>

<script>
export default {
  name: "Edit",
  props: {
    user: Object
  },
  data() {
    return {
      editInputUsername: null,
      editInputEmail: null
    }
  },
  methods: {
    saveUserInfo() {
      var myHeaders = new Headers();
      myHeaders.append("Content-Type", "application/json");

      var raw = JSON.stringify({
        "users":
            {
              "username": this.editInputUsername,
              "email": this.editInputEmail
            }
      });

      var requestOptions = {
        method: 'PUT',
        headers: myHeaders,
        body: raw,
        redirect: 'follow'
      };

      fetch("http://localhost:4000/api/users/" + this.user.id, requestOptions)
          .then(function(response) {
            if (!response.ok) {
              throw Error(response.statusText);
            }
            return response;
          })
          .then(response => response.text())
          .then(result => {
            console.log(result)
            result = JSON.parse(result);
            console.log(result)
            this.$emit('successful-login', result.data);
          })
          .catch(error => console.log('error', error));
    },
    deleteUser() {

      var requestOptions = {
        method: 'DELETE',
        redirect: 'follow'
      };

      fetch("http://localhost:4000/api/users/" + this.user.id, requestOptions)
          .then(function(response) {
            if (!response.ok) {
              throw Error(response.statusText);
            }
            return response;
          })
          .then(response => response.text())
          .then(result => {
            //TODO on veut juste savoir si la requete a fonctionner
            console.log(result)
            if (result) {
              result = JSON.parse(result);
              console.log(result)
            }
            //on on emet un event  successful-logout ---> on se deconnecte. Les donnes de l'utilisateur sont reset dans App.vue (le parent)
            this.$emit('successful-logout');
            // this.$router.push("/");
          })
          .catch(error => console.log('error', error));
    }
  }
}
</script>

<style scoped>
html,
body {
  height: 100%;
}

body {
  display: -ms-flexbox;
  display: flex;
  -ms-flex-align: center;
  align-items: center;
  padding-top: 40px;
  padding-bottom: 40px;
  background-color: #f5f5f5;
}

.form-signin {
  width: 100%;
  max-width: 330px;
  padding: 15px;
  margin: auto;
}

.form-signin .checkbox {
  font-weight: 400;
}

.form-signin .form-control {
  position: relative;
  box-sizing: border-box;
  height: auto;
  padding: 10px;
  font-size: 16px;
}

.form-signin .form-control:focus {
  z-index: 2;
}

.form-signin input[type="email"] {
  margin-bottom: -1px;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}

.form-signin input[type="password"] {
  margin-bottom: 10px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}
</style>