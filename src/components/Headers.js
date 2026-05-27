import {Link} from 'react-router-dom';
import {useEffect, useState} from "react";
import Highcharts from "highcharts";
import HighchartsReact from "highcharts-react-official";

function Header({ auth, setAuth })
{
return(
    <header className="header">
    <div className="header-top">
    <div className="header-left">CristOfBooking</div>

    <div className="header-right">
    <Link to="/about">
    <button className='About'>About</button>
  </Link>

  <Link to="/dashboard">
    <button className='dashboard'>dashboard</button>
  </Link>

  {!auth ? (<>
      <Link to="/login">
        <button className="login">Login</button>
      </Link>

      <Link to="/register">
        <button className="register">Register</button>
      </Link>
    </>):(<>
      <Link to="/account">
        <button className="login">My Account</button>
      </Link>

      <button className="logout"
        onClick={() => {
          localStorage.removeItem("token");
          setAuth(false);
        }}
      >
        Logout
      </button>
    </>
  )}
    </div>
    </div>
    <div className="header-text">
        <h1>Найдите жилье для новой поездки!</h1>
        <h3>Ищите спецпредложения на отели, дома и другие варианты.</h3></div>
</header>
)
}

export function Navbar({ auth, setAuth }) {
  return (
    <nav>
      {!auth ? (<>
          <a href="/login">Login</a>
          <a href="/register">Register</a>
        </>):(<> <a href="/account">My Account</a>
          <button
            onClick={() => {
              localStorage.removeItem("token");
              setAuth(false);}}>
            Logout
          </button></>)}
    </nav>
  );
}
export function Register() {
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleRegister = async (e) => {
    e.preventDefault();

    const res = await fetch("http://127.0.0.1:5000/api/auth/register", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        username,
        email,
        password,
      }),});

    const data = await res.json();
    console.log(data);

    if (res.ok) {
      alert("Регистрация успешна");
      window.location.href = "/login";
    } else {
      alert(data.error);
    }
  };

  return (
    <div className="back_register">
      <button
        className="back-home"
        onClick={() => (window.location.href = "/")}
      >
        ← На главную
      </button>

      <form className="register_rel" onSubmit={handleRegister}>
        <h2>Зарегистрироваться</h2>

        <p>Введите имя:</p>
        <input
          value={username}
          onChange={(e) => setUsername(e.target.value)}/>

        <p>Введите email:</p>
        <input
          value={email}
          onChange={(e) => setEmail(e.target.value)}/>

        <p>Введите пароль:</p>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}/>

        <button type="submit">Отправить</button>

        <Link to="/login">
          <p>Если у вас есть аккаунт</p>
        </Link>
      </form>
    </div>
  );
}
export function Login({ setAuth }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleLogin = async (e) => {
    e.preventDefault();

    const res = await fetch("http://127.0.0.1:5000/api/auth/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        email,
        password,
      }),});

    const data = await res.json();

    if (res.ok) {
  localStorage.setItem("token", data.token);
  localStorage.setItem("user", JSON.stringify(data.user));

  setAuth(true); 

  window.location.href = "/";}
  else {
      alert(data.error);
    }
  };

  return (
    <main className="back_login">
      <button
        className="back-home"
        onClick={() => (window.location.href = "/")}
      >
        ← На главную
      </button>

      <form className="login_rel" onSubmit={handleLogin}>
        <h2>Войти в аккаунт</h2>

        <p>Введите email:</p>
        <input
          value={email}
          onChange={(e) => setEmail(e.target.value)}/>

        <p>Введите пароль:</p>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}/>

        <button type="submit">Отправить</button>

        <Link to="/register">
          <p>Если вы еще не зарегистрировлись</p>
        </Link>
      </form>
    </main>);}
export function About(){
    return(
        <div className='back_about'>
            <button
        className="back-home"
        onClick={() => (window.location.href = "/")}
      >
        ← На главную
      </button>
            <h1>Веб-приложение для бронирования отелей!</h1>
           <p>Современная платформа для поиска и бронирования отелей с удобным интерфейсом и системой оплаты.</p>
           <h2>Функционал приложения</h2>
           <ul>
            <li>✅ Регистрация пользователей (создание аккаунта)</li>
            <li>🏨 Просмотр отелей (фото, описание, цена)</li>
            <li>🔍 Фильтрация по цене, городу и рейтингу</li>
           </ul>
        </div>
    )
}
export function Dashboard() {
  const [guests, setGuests] = useState([]);

  useEffect(() => {
    fetch("http://127.0.0.1:5000/api/guests")
      .then((res) => res.json())
      .then((data) => setGuests(data))
      .catch((err) => console.log(err));
  }, []);

  
  const countryCount = {};

  guests.forEach((guest) => {
    countryCount[guest.country] =
      (countryCount[guest.country] || 0) + 1;
  });

  const countryData = Object.keys(countryCount).map((country) => ({
    name: country,
    y: countryCount[country],
  }));


  const monthCount = {};

  guests.forEach((guest) => {
    const date = new Date(guest.registered_at);
    const month = date.toLocaleString("default", {
      month: "long",
    });

    monthCount[month] =
      (monthCount[month] || 0) + 1;
  });

  const monthData = Object.keys(monthCount).map((month) => ({
    name: month,
    y: monthCount[month],
  }));


  const countryOptions = {
    chart: {
      type: "pie",
    },
    title: {
      text: "Гости по странам",
    },
    series: [
      {
        name: "Количество",
        data: countryData,
      },],};

  
  const monthOptions = {
    chart: {
      type: "column",
    },
    title: {
      text: "Регистрации по месяцам",
    },
    xAxis: {
      type: "category",
    },
    yAxis: {
      title: {
        text: "Количество гостей",
      },
    },
    series: [
      {
        name: "Регистрации",
        data: monthData,
      },
    ],
  };

  return (
    <div style={{ padding: "40px" }}>
      <button
        className="back-home"
        onClick={() => (window.location.href = "/")}
      >
        ← На главную
      </button>
      <HighchartsReact highcharts={Highcharts} options={countryOptions}/>

      <br />
      <br />

      <HighchartsReact
        highcharts={Highcharts}
        options={monthOptions}
      />
    </div>
  );
}
export default Header
