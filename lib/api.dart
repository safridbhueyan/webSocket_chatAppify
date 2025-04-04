
class Api {

static const login = "192.168.4.3:3000/api/auth/login";
static const user = "192.168.4.3:3000/api/users";
static const send = "192.168.4.3:3000/api/messages";
static String receive(String name) => "192.168.4.3:3000/api/messages?user=$name";

}