import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function Account() {
  const [user, setUser] = useState(null);
  const [bookings, setBookings] = useState([]);
  const [payingId, setPayingId] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem("token");

    if (!token) {
      navigate("/login");
      return;
    }

    const savedUser = JSON.parse(localStorage.getItem("user"));

    if (!savedUser) {
      navigate("/login");
      return;
    }

    setUser(savedUser);

    fetch(`http://127.0.0.1:5000/api/users/${savedUser.id}/bookings`)
      .then((res) => res.json())
      .then((data) => setBookings(data))
      .catch((err) => console.log(err));
  }, [navigate]);
  
  const deleteBooking = async (id) => {
    await fetch(`http://127.0.0.1:5000/api/bookings/${id}`, {
      method: "DELETE",
    });

    setBookings((prev) => prev.filter((b) => b.id !== id));
  };
const logout = () => {
  localStorage.removeItem("token");
  localStorage.removeItem("user");
  window.location.href = "/";
};
  const payBooking = async (id) => {
    try {
      const res = await fetch(
        `http://127.0.0.1:5000/api/bookings/${id}/pay`,
        { method: "POST" }
      );
  
      const data = await res.json();

      if (!res.ok) {
        alert(data.error || "Ошибка оплаты");
        return;
      }

      setBookings((prev) =>
        prev.map((b) =>
          b.id === id ? { ...b, status: "paid" } : b
        )
      );

      setPayingId(null);
    } catch (err) {
      alert("Ошибка сети");
    }
  };

  if (!user) return <p>Loading...</p>;

  return (
    <div className="account">
      <button className="back-home" onClick={() => (window.location.href = "/")}>
        ← На главную
      </button>
      <div className="account_card">
        <h1>Личный кабинет</h1>
        <p><b>ID:</b> {user.id}</p>
        <p><b>Email:</b> {user.email}</p>
        <p><b>Username:</b> {user.username}</p>
        <button className="logout" onClick={logout}>
          Выйти
        </button>
      </div>

      <div className="account_bookings">
        <h2 style={{
          marginLeft:"40px"
        }}>Мои бронирования</h2>

        {bookings.map((b) => {
          const isPaid = b.status === "paid";

          return (
            <div key={b.id} className="booking_card">
              <p><b>Отель:</b> {b.hotel_name}</p>
              <p><b>Комната:</b> {b.room_type}</p>
              <p><b>Заезд:</b> {b.check_in}</p>
              <p><b>Выезд:</b> {b.check_out}</p>
              <p><b>Статус:</b> {b.status}</p>

              <div style={{ display: "flex", gap: 10 }}>
                
                <button className="Delete"
                  onClick={() => deleteBooking(b.id)}
                  disabled={isPaid}
                >
                  Удалить
                </button>

                <button className="Pay"
                  onClick={() => setPayingId(b.id)}
                  disabled={isPaid}
                  
                >
                  {isPaid ? "Оплачено" : "Оплатить"}
                </button>

              </div>
            </div>
            
          );
        })}
      </div>

      {payingId && (
        <PaymentModal
          onClose={() => setPayingId(null)}
          onPay={() => payBooking(payingId)}
        />
      )}

    </div>
  );
}
function PaymentModal({ onPay, onClose }) {
  const [card, setCard] = useState("");
  const [exp, setExp] = useState("");
  const [cvv, setCvv] = useState("");

  return (
    <div className="modal">
      <div className="modal_box">
        <h2>Оплата</h2>

        <input placeholder="Card number" value={card} onChange={(e) => setCard(e.target.value)} />
        <input placeholder="MM/YY" value={exp} onChange={(e) => setExp(e.target.value)} />
        <input placeholder="CVV" value={cvv} onChange={(e) => setCvv(e.target.value)} />

        <button onClick={onPay}>Оплатить</button>
        <button onClick={onClose}>Отмена</button>
      </div>
    </div>
  );
}