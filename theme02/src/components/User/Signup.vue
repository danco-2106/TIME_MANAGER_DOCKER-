<template>
  <form class="form-signin" @submit.prevent="createUser">
    <img class="mb-4" src="../../assets/logo.png" alt="" width="250" height="250">
    <h1 class="h3 mb-3 font-weight-normal">Please fill in your information</h1>

    <p v-if="errors.length" class="alert-danger">
      <b>Please correct the following error(s):</b>
    <ul>
      <li v-for="error in errors" v-bind:key="error.id">{{ error }}</li>
    </ul>
    </p>

    <label for="signupInputEmail" class="sr-only">Email address</label>
    <input v-model="signupInputEmail" type="email" id="signupInputEmail" class="form-control"
           placeholder="Email address" required autofocus>
    <label for="signupInputUsername" class="sr-only">Username</label>
    <input v-model="signupInputUsername" type="text" id="signupInputUsername" class="form-control"
           placeholder="Username" required>
    <label for="signupInputPassword" class="sr-only">Password</label>
    <input v-model="signupInputPassword" type="password" id="signupInputPassword" class="form-control"
           placeholder="Password" required>
<!--    {{ selectedRole }}-->
    <div class="dropdown">
      <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownRoleBtn" data-toggle="dropdown"
              aria-haspopup="true" aria-expanded="false">
        Please select a role
      </button>
      <div class="dropdown-menu text-left ml-auto" aria-labelledby="dropdownMenuButton">
        <div class="radio">
          <label><input v-model="selectedRole" type="radio" id="empRole" name="radioRoles" value="Employee">
            Employee</label>
        </div>
        <div class="radio">
          <label><input v-model="selectedRole" type="radio" id="manRole" name="radioRoles" value="Manager">
            Manager</label>
        </div>
        <div class="radio">
          <label><input v-model="selectedRole" type="radio" id="genRole" name="radioRoles" value="General Manager">
            General Manager</label>
        </div>
      </div>
    </div>
    <br>
    <button class="btn btn-lg btn-primary btn-block" type="submit">Sign up</button>
    <p class="mt-5 mb-3 text-muted">&copy; 2017-2020</p>
  </form>
</template>

<script>
export default {
  name: "Signup",
  data() {
    return {
      signupInputEmail: null,
      signupInputUsername: null,
      signupInputPassword: null,
      selectedRole: "Employee",
      errors: []
    }
  },
  methods: {
    validateEmail(email) {
      const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(String(email).toLowerCase());
    },
    validatePasswordLength(password) {
      if (password == null)
        return false;
      else
        return password.length >= 5;
    },
    checkForm() {
      let status = true;
      this.errors = [];
      if (!this.validateEmail(this.signupInputEmail)) {
        this.errors.push('Please fix your email. It should look something like X@X.X')
        status = false;
      }
      if (!this.validatePasswordLength(this.signupInputPassword)) {
        this.errors.push('Your password needs to be at least 8 characters long.')
        status = false;
      }
      return status;
    },
    updateCurrentUser: function (loggedUser) {
      this.$emit('successful-login', loggedUser);
    },
    createUser() {
      //debug
      console.log(this.signupInputEmail);
      console.log(this.signupInputUsername);
      console.log(this.signupInputPassword);
      console.log(this.selectedRole);
      console.log(this.checkForm());

      if (this.checkForm()) {
        var myHeaders = new Headers();
        myHeaders.append("Content-Type", "application/json");

        var raw = JSON.stringify({
          "users":
              {
                "username": this.signupInputUsername,
                "email": this.signupInputEmail,
                "password": this.signupInputPassword,
                "role": this.selectedRole
              }
        });

        var requestOptions = {
          method: 'POST',
          headers: myHeaders,
          body: raw,
          redirect: 'follow'
        };

        fetch("http://localhost:4000/api/users/sign_up", requestOptions)
            .then(function (response) {
              if (!response.ok) {
                throw Error(response.statusText);
              }
              return response;
            })
            .then(response => response.text())
            .then(result => {
              // console.log(result)
              result = JSON.parse(result);
              console.log(result)
              this.updateCurrentUser(result);
              this.$router.push("/");
            })
            .catch(error => console.log('error', error));
      } else {
        //do nothing
      }
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