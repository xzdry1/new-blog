import api from '../api';

export default {
  fetchCategory: (state) => {
    return api.category.fetchCategoryList().then(categoryList => {
      state.commit('setCategories', categoryList);
    });
  },
  fetchTags: state => {
    return api.tag.fetchTagsList().then(tags => {
      state.commit('setTags', tags);
    })
  },
  fetchWidget: state => {
    return api.widget.fetchWidgetList().then(widgets => {
      state.commit('setWidgets', widgets);
    });
  },
  fetchPostsByCategory: (state, params) => {
    state.commit('setBusy', true);
    return api.category.fetchPostsByCategory(params).then(data => {
      state.commit('setPages', data.page);
      state.commit('setPosts', data.posts);
      state.commit('setBusy', false);
    });
  },
  fetchPostsByTag: (state, params) => {
    state.commit('setBusy', true);
    state.commit('setPosts', []);
    return api.tag.fetchPostsByTag(params).then(data => {
      state.commit('setPages', data.page);
      state.commit('setPosts', data.posts);
      state.commit('setBusy', false);
    });
  },
  fetchLatestPosts: (state, params) => {
    state.commit('setBusy', true);
    state.commit('setPosts', []);
    return api.post.fetchPosts(params).then(data => {
      state.commit('setPages', data.page);
      state.commit('setPosts', data.posts);
      state.commit('setBusy', false);
    });
  },
  fetchPostBySlug: (state, slug) => {
    state.commit('setBusy', true);
    state.commit('setPost', []);
    return api.post.fetchPostBySlug({ slug }).then(post => {
      state.commit('setPost', post);
      state.commit('setBusy', false);
    });
  },

}