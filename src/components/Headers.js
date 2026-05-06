import {Link} from 'react-router-dom';
function Header()
{
return(
    <header className="header">
    <div className="header-top">
    <div className="header-left">CristOfBooking</div>
    <div className="header-right">
    <Link to ="/login">
    <button className="login">Login</button>
    </Link>
    <Link to="/register">
    <button className="register">Register</button>
    </Link>
    </div>
    </div>
    <div className="header-text">
        <h1>Найдите жилье для новой поездки!</h1>
        <h3>Ищите спецпредложения на отели, дома и другие варианты.</h3></div>
</header>
)
}
export function Login()
{
return(
    <main className="back_login">
<form className='login_rel'> 
    <h2>Войти в аккаунт</h2>   
    <p>Введите свое имя:</p>
    <input></input>
    <p>Введите свой пароль:</p>
    <input></input>
    <button>Отправить</button>
    <Link to="/register">
    <p>Если вы еще не зарегистрировались</p>
    </Link>
</form>
</main>)
}
export function Register(){
    return(
        <div className='back_register'>
<form className='register_rel'> 
    <h2>Зарегистрироваться </h2>   
    <p>Введите свое имя:</p>
    <input></input>
    <p>Введите свой пароль:</p>
    <input></input>
    <button>Отправить</button>
    <Link to="/login">
    <p>Если у вас есть аккаунт</p>
    </Link>
</form>
</div>
    )
}
export default Header