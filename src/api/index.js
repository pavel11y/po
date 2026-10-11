const API = 'http://localhost:3001/api'

async function request(url, options = {}) {
  let response
  try {
    response = await fetch(API + url, {
      headers: { 'Content-Type': 'application/json', ...(options.headers || {}) },
      ...options,
    })
  } catch (e) {
    throw new Error('Технические работы. Не удалось соединиться с сервером.')
  }
  const data = await response.json().catch(() => ({}))
  if (!response.ok) throw new Error(data.error || 'Ошибка запроса')
  return data
}

export const api = {
  login: (email, password) =>
    request('/login', { method: 'POST', body: JSON.stringify({ email, password }) }),
  register: (name, email, password, phone) =>
    request('/register', { method: 'POST', body: JSON.stringify({ name, email, password, phone }) }),
  forgotPassword: (email) =>
    request('/forgot-password', { method: 'POST', body: JSON.stringify({ email }) }),
  resetPassword: (email, code, newPassword) =>
    request('/reset-password', { method: 'POST', body: JSON.stringify({ email, code, newPassword }) }),

  services: () => request('/services'),
  addService: (data, current_user_id) => request(`/services?current_user_id=${current_user_id}`, {
    method: 'POST', body: JSON.stringify({ ...data, current_user_id }),
  }),
  updateService: (id, data, current_user_id) => request(`/services/${id}?current_user_id=${current_user_id}`, {
    method: 'PUT', body: JSON.stringify({ ...data, current_user_id }),
  }),
  deleteService: (id, current_user_id) =>
    request(`/services/${id}?current_user_id=${current_user_id}`, { method: 'DELETE' }),

  categories: () => request('/categories'),
  addCategory: (title, current_user_id) => request(`/categories?current_user_id=${current_user_id}`, {
    method: 'POST', body: JSON.stringify({ title, current_user_id }),
  }),
  updateCategory: (id, title, current_user_id) =>
    request(`/categories/${id}?current_user_id=${current_user_id}`, {
      method: 'PUT', body: JSON.stringify({ title, current_user_id }),
    }),
  deleteCategory: (id, current_user_id) =>
    request(`/categories/${id}?current_user_id=${current_user_id}`, { method: 'DELETE' }),

  cart: (userId) => request(`/cart/${userId}`),
  addToCart: (user_id, service_id, quantity = 1) =>
    request('/cart', { method: 'POST', body: JSON.stringify({ user_id, service_id, quantity }) }),
  updateCartItem: (id, quantity) =>
    request(`/cart/${id}`, { method: 'PUT', body: JSON.stringify({ quantity }) }),
  removeCartItem: (id) => request(`/cart/${id}`, { method: 'DELETE' }),
  clearCart: (userId) => request(`/cart/user/${userId}`, { method: 'DELETE' }),

  createOrder: (user_id, address, delivery_date) =>
    request('/orders', { method: 'POST', body: JSON.stringify({ user_id, address, delivery_date }) }),
  myOrders: (userId) => request(`/orders/user/${userId}`),
  allOrders: (current_user_id) => request(`/orders?current_user_id=${current_user_id}`),
  updateOrderStatus: (id, status, current_user_id) =>
    request(`/orders/${id}/status?current_user_id=${current_user_id}`, {
      method: 'PUT', body: JSON.stringify({ status, current_user_id }),
    }),

  reviewsForService: (serviceId) => request(`/reviews/service/${serviceId}`),
  allReviews: (current_user_id) => request(`/reviews?current_user_id=${current_user_id}`),
  addReview: (user_id, service_id, rating, comment) =>
    request('/reviews', { method: 'POST', body: JSON.stringify({ user_id, service_id, rating, comment }) }),
  updateReview: (id, user_id, rating, comment) =>
    request(`/reviews/${id}`, {
      method: 'PUT', body: JSON.stringify({ user_id, rating, comment }),
    }),
  adminUpdateReview: (id, rating, comment, current_user_id) =>
    request(`/reviews/${id}/admin?current_user_id=${current_user_id}`, {
      method: 'PUT', body: JSON.stringify({ rating, comment, current_user_id }),
    }),
  deleteReview: (id, current_user_id, reason) =>
    request(`/reviews/${id}?current_user_id=${current_user_id}`, {
      method: 'DELETE', body: JSON.stringify({ current_user_id, reason }),
    }),

  users: (current_user_id) => request(`/users?current_user_id=${current_user_id}`),
  updateProfile: (id, data) =>
    request(`/profile/${id}`, { method: 'PUT', body: JSON.stringify(data) }),
  changePassword: (id, old_password, new_password) =>
    request(`/profile/${id}/password`, {
      method: 'PUT', body: JSON.stringify({ old_password, new_password }),
    }),
}