class ApiConstants {
static const baseUrl = 'https://app.alshahbndr.co';
static const login = '${baseUrl}/api/v1/auth/login';
static const register = '${baseUrl}/api/v1/auth/register';
static const sendSms = '${baseUrl}/api/v1/sms/send';
static const verifySms = '${baseUrl}/api/v1/sms/verify';
static const changePassword = '${baseUrl}/api/v1/user/password/change';
static const getPaginatedBrands = '${baseUrl}/api/v1/brands/get?page=1';
static const getPaginatedQuestions = '${baseUrl}/api/v1/questions/get?page=1&';
static const contactForm = '${baseUrl}/api/v1/contact/store';
static const paginatedBlogs = '${baseUrl}/api/v1/blogs/get';
static const paginatedCategories = '${baseUrl}/api/v1/categories/get?perPage=50&page=1&';
static const showBlog = '${baseUrl}/api/v1/blog/show/1';
static const updateUserProfile = '${baseUrl}/api/v1/user/profile/update';
static const appSettings = '${baseUrl}/api/v1/settings/get';
static const updateUserToken = '${baseUrl}/api/v1/user/update-token';
static const userNotifications = '${baseUrl}/api/v1/notifications/get?perPage=10&page=2';
static const images = '${baseUrl}/api/v1/images/get';

}