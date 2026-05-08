import {Link} from 'react-router-dom';
function Header()
{
return(
    <header className="header">
    <div className="header-top">
    <div className="header-left">CristOfBooking</div>

    <div className="header-right">
    <Link to = "/about">
    <button className='About'>About</button>
    </Link>
    <Link to="dashboard">
    <button className='dashboard'>dashboard</button>
    </Link>
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
export function About(){
    return(
        <div className='back_about'>
            <h1>Веб-приложение для бронирования отелей!</h1>
           <p>Современная платформа для поиска и бронирования отелей с удобным интерфейсом и системой оплаты.</p>
           <hr/>
           <h2>Участники приложения</h2>
           <div className='team'>
           <div>🔧 Backend — Обод Даниил — @obbodokk</div>
           <div>🎨 Frontend — Маврин Данил — @Pikabys</div>
           <div>🗄️ Database — Кучеренко Тимофей — @blacksuitcl</div>
           <div>🧪 Testing — Малышев Михаил — @mike03bratok</div>
           </div>
           <hr/>
           <h2>Функционал приложения</h2>
           <ul>
            <li>✅ Регистрация пользователей (создание аккаунта)</li>
            <li>🏨 Просмотр отелей (фото, описание, цена)</li>
            <li>🔍 Фильтрация по цене, городу и рейтингу</li>
           </ul>
        </div>
    )
}
export function Dashboard(){
    return(
        <div className='back_dashboard'>
            <h1>Веб-приложение для бронирования отелей!</h1>
           <p>Современная платформа для поиска и бронирования отелей с удобным интерфейсом и системой оплаты.</p>
           <h2></h2>
           <div className='team'>
           <div>🔧 Backend — Обод Даниил — @obbodokk</div>
           <div>🎨 Frontend — Маврин Данил — @Pikabys</div>
           <div>🗄️ Database — Кучеренко Тимофей — @blacksuitcl</div>
           <div>🧪 Testing — Малышев Михаил — @mike03bratok</div>
           </div>
           <h2>Функционал приложения</h2>
           <ul>
            <li>✅ Регистрация пользователей (создание аккаунта)</li>
            <li>🏨 Просмотр отелей (фото, описание, цена)</li>
            <li>🔍 Фильтрация по цене, городу и рейтингу</li>
           </ul>
        </div>
    )
}
export default Header