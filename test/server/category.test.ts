'use strict';

import * as supertest from 'supertest';
import { expect } from 'chai';

import site from '../../index';
const agent = supertest.agent(site);

describe('Testing category-related APIs.', () => {
  let categories: string[];

  it('Fetch category list', async () => {
    const url = '/api/category';
    const response = await agent.get(url).expect(200);

    expect(response.body.status).to.be.ok;
    expect(response.body.categories).not.to.be.undefined;

    categories = response.body.categories;
    console.log(categories);
  });

  it('Fetch posts under category', async () => {
    const url = `/api/category/${encodeURIComponent(categories[0])}/posts`;
    const response = await agent.get(url).expect(200);
    expect(response.body.status).to.be.ok;
    expect(response.body.posts).not.to.be.undefined;
  });

  it('Fetch posts under category with page', async () => {
    const url = `/api/category/${encodeURIComponent(categories[0])}/posts?page=1`;
    const response = await agent.get(url).expect(200);
    expect(response.body.status).to.be.ok;
    expect(response.body.posts).not.to.be.undefined;
  });

  it('Fetch posts under category with out-of-ranged page', async () => {
    const url = `/api/category/${encodeURIComponent(categories[0])}/posts?page=100`;
    const response = await agent.get(url).expect(404);
    expect(response.body.status).equals('error');
  });
});