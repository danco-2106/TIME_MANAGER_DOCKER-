<template>
  <div id="app">
    <nav class="navbar navbar-expand-md navbar-dark bg-dark">
      <!--      <a v-on:click="clickHome" class="navbar-brand">Time Manager</a>-->
      <router-link to="/" class="navbar-brand">Time Manager</router-link>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample04"
              aria-controls="navbarsExample04" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarsExample04">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item active">
            <router-link to="/" class="nav-link">Home <span class="sr-only">(current)</span></router-link>
          </li>
          <li class="nav-item active">
            <router-link to="/clocking" v-if="userLoggedIn" class="nav-link">Clocking <span
                class="sr-only">(current)</span></router-link>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="dropdown04" data-toggle="dropdown"
               aria-haspopup="true" aria-expanded="false">{{ user.username }}</a>
            <div class="dropdown-menu" aria-labelledby="dropdown04">
              <router-link to="/login" v-if="userLoggedOut" class="dropdown-item">Log in</router-link>
              <router-link to="/signup" v-if="userLoggedOut" class="dropdown-item">Sign up</router-link>
              <router-link to="/edit" v-if="userLoggedIn" class="dropdown-item">Edit</router-link>
              <a v-if="userLoggedIn" v-on:click="userLogout" class="dropdown-item">Log out</a>
            </div>
          </li>
          <li class="nav-item">
            <router-link to="/workingtimes" v-if="userLoggedIn" class="nav-link">Working Times</router-link>
          </li>
        </ul>
      </div>
    </nav>
    <router-view @successful-login="userLogin" @successful-logout="userLogout" :user="user"></router-view>
  </div>
</template>

<script>

export default {
  name: 'App',
  methods: {
    userLogin(loggedUser) {
      this.user = loggedUser;
      this.userLoggedIn = true;
      this.userLoggedOut = false;
    },
    userLogout() {
      this.user = {
        username: "Log in", email: "", id: -1
      };
      this.userLoggedIn = false;
      this.userLoggedOut = true;
      this.$router.push("/");
    },
  }
  ,
  data() {
    return {
      user: {
        username: "Log in",
        email: "",
        id: -1
      },
      userLoggedIn: false,
      userLoggedOut: true
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 0px;
  /*height: 100vh;*/
}

body {
  padding-bottom: 20px;
}

.navbar {
  margin-bottom: 20px;
}
</style>
