window.auth = {
	getCookie: function (name) {
		const value = `; ${document.cookie}`;
		const parts = value.split(`; ${name}=`);
		
		if (parts.length === 2)
			return parts.pop().split(';').shift();

		return null;
	},

	setCookie: function (name, value, days) {
		const date = new Date();

		date.setTime(
			date.getTime() + (days * 24 * 60 * 60 * 1000)
		);

		document.cookie = `${name}=${value}; expires=${date.toUTCString()}; path=/`;
	}

}