import Raphael from 'raphael/raphael'

global.Raphael = Raphael
import Vue from 'vue'
import App from './App.vue'
import Grid from 'gridjs-vue'
import { BTable } from 'bootstrap-vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import 'bootstrap/dist/css/bootstrap.min.css'
import Homepage from "@/components/Homepage";
import Login from "@/components/User/Login";
import Signup from "@/components/User/Signup";
import Edit from "@/components/User/Edit";
import Workingtimes from "@/components/Workingtimes/Workingtimes";
import Workingtime from "@/components/Workingtime/Workingtime";
import Clocking from "@/components/Clocking/Clocking";
import NotFound from "@/components/NotFound";

Vue.config.productionTip = false
Vue.component('b-table', BTable)

const routes = [
    {path: '/', component: Homepage},
    {path: '/login', component: Login},
    {path: '/edit', component: Edit},
    {path: '/signup', component: Signup},
    {path: '/workingtimes', component: Workingtimes},
    {path: '/workingtime', component: Workingtime},
    {path: '/clocking', component: Clocking},
    {path: '*', component: NotFound}
]

const router = new VueRouter({
    mode: 'history',
    routes: routes
})
new Vue({
    router,
    render: h => h(App),
}).$mount('#app')
Vue.use(Grid)
