<template lang="pug">
  div.side-bar.admin-side-bar
    div.card
      h3.title Functions
      ul
        li: router-link(to="/admin/post/new") 创建文章
        li: router-link(to="/admin/post") 管理文章
        li: router-link(to="/admin/widgets") 管理小工具
        li: router-link(to="/admin/page") 管理页面
        li: router-link(to="/admin/media") 管理媒体
        li(v-for="unit in extraAdminUnits"): router-link(:to="unit.href") {{ unit.name }}
        li: router-link(to="/admin/logs") 访问日志
        li: router-link(to="/admin?logout=true")  注销登陆
</template>

<script>
import io from 'socket.io-client';

import SiteTitle from '../SiteTitle.vue';
import config from '../../config.json';

export default {
  name: 'AdminSideBar',
  components: {
    SiteTitle
  },
  computed: {
    extraAdminUnits () {
      return this.$store.state.extraAdminUnits;
    }
  }
};

</script>

<style lang="scss">
@import '../../style/global.scss';

.admin-side-bar {
  ul {
    list-style: none;
    padding: 0;
    line-height: 2em;
  }

  li {
    padding-left: 1em;

    a {
      display: block;
      text-decoration: none;
    }

    a:hover {
      border: none;
    }
  }

  li:hover {
    background-color: mix($background_color, lightgrey, 80%);
  }
}

</style>