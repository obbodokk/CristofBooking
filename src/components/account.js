import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function Account() {
  const [user, setUser] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem("token");

    if (!token) {
      navigate("/login");
      return;
    }

    const savedUser = JSON.parse(localStorage.getItem("user"));
    setUser(savedUser);
  }, []);

  const logout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    window.location.href = "/";
  };

  if (!user) return <p>Такого пользователя нет</p>;

  return (
    <div className="account">
        <button className="back-home" onClick={() => window.location.href="/"}>{"← На главную"}</button>

        
      <div className="account_card">
        <h1>Личный кабинет</h1>
        <p><b>ID:</b> {user.id}</p>
        <p><b>Email:</b> {user.email}</p>
        <p><b>Username:</b> {user.username}</p>
        <button className="logout" onClick={logout}>
        Выйти
      </button>
      </div>
    </div>
  );
}