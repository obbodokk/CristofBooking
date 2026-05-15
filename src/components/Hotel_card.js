import { useEffect, useState, useRef } from "react";
import { useParams } from "react-router-dom";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

export default function HotelCard() {
  const { id } = useParams();
  const familyRef = useRef(null);

  const [hotel, setHotel] = useState(null);
  const [rooms, setRooms] = useState([]);
  const [selectedRoom, setSelectedRoom] = useState(null);

  const [checkIn, setCheckIn] = useState(null);
  const [checkOut, setCheckOut] = useState(null);

  const [parents, setParents] = useState(2);
  const [children, setChildren] = useState(0);
  const [numbers, setNumbers] = useState(1);
  const [familyOpen, setFamilyOpen] = useState(false);

  const [totalPrice, setTotalPrice] = useState(0);

  const guests = parents + children;

  useEffect(() => {
    const handleClickOutside = (e) => {
      if (familyRef.current && !familyRef.current.contains(e.target)) {
        setFamilyOpen(false);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);

    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  useEffect(() => {
    fetch(`http://127.0.0.1:5000/api/hotels/${id}`)
      .then((res) => res.json())
      .then((data) => setHotel(data));

    fetch(`http://127.0.0.1:5000/api/hotels/${id}/rooms`)
      .then((res) => res.json())
      .then((data) => setRooms(data));
  }, [id]);

  useEffect(() => {
    if (!selectedRoom || !checkIn || !checkOut) {
      setTotalPrice(0);
      return;
    }

    const diff = checkOut - checkIn;
    const nights = Math.ceil(diff / (1000 * 60 * 60 * 24));

    if (nights <= 0) {
      setTotalPrice(0);
      return;
    }

    const price = selectedRoom.price * nights * numbers;
    setTotalPrice(price);
  }, [selectedRoom, checkIn, checkOut, numbers]);

  const isOverLimit =
    selectedRoom && guests > selectedRoom.max_guests;

  const handleBooking = async () => {
    if (!selectedRoom) {
      return alert("Выберите номер");
    }

    if (isOverLimit) {
      return alert(`Максимум ${selectedRoom.max_guests} гостей`);
    }

    if (!checkIn || !checkOut) {
      return alert("Выберите даты");
    }

    const token = localStorage.getItem("token");

    if (!token) {
      alert("Сначала войдите в аккаунт");
      window.location.href = "/login";
      return;
    }

    const bookingData = {
      hotel_id: Number(id),
      room_id: selectedRoom.id,
      check_in: checkIn.toISOString(),
      check_out: checkOut.toISOString(),
      total_price: totalPrice,
      number_of_guests: parents + children
    };

    const res = await fetch("http://127.0.0.1:5000/api/bookings", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`,
      },
      body: JSON.stringify(bookingData),
    });

    const text = await res.text();

console.log(text);

if (res.ok) {
  alert("Успешно забронировано!");
} else {
  alert(text);
}
  };

  if (!hotel) return <h1>Loading...</h1>;

  return (
    <div className="hotel-details">
      <button
        className="back-home"
        onClick={() => (window.location.href = "/")}
      >
        ← На главную
      </button>

      <img src={hotel.image_url} alt={hotel.name} />

      <h1>{hotel.name}</h1>
      <p>{hotel.location}</p>
      <p>{hotel.address}</p>
      <p>{hotel.phone}</p>
      <p>{hotel.email}</p>
      <p>{hotel.amenities.join(", ")}</p>

      <h2>Номера</h2>

      <div className="rooms-grid">
        {rooms.map((room) => {
          const img = room.image
            .replace("{", "")
            .replace("}", "")
            .split(",")[0];

          return (
            <div
              key={room.id}
              className={`room-card ${
                selectedRoom?.id === room.id ? "selected" : ""
              }`}
              onClick={() => setSelectedRoom(room)}
            >
              <img src={img} alt={room.type} />

              <h3>{room.type}</h3>
              <p>{room.description}</p>
              <p>Max: {room.max_guests}</p>
              <p>${room.price}</p>
            </div>
          );
        })}
      </div>

      <div className="booking-box">
        <h2>Бронирование</h2>

        <DatePicker
          selectsRange
          startDate={checkIn}
          endDate={checkOut}
          onChange={(dates) => {
            const [start, end] = dates;
            setCheckIn(start);
            setCheckOut(end);
          }}
          minDate={new Date()}
          placeholderText="Выберите даты"/>

        <div className="wrap" ref={familyRef}>
          <input readOnly onFocus={() => setFamilyOpen(true)} placeholder={`${parents} взрослых - ${children} детей - ${numbers} номеров`}/>

          {familyOpen && (
            <ul className="family">
              <li>
                Взрослых
                <button
                  onClick={() =>
                    setParents(Math.max(0, parents - 1))
                  }>
                  -
                </button>

                {parents}

                <button
                  onClick={() => setParents(parents + 1)}>
                  +
                </button>
              </li>

              <li>
                Детей
                <button
                  onClick={() =>
                    setChildren(Math.max(0, children - 1))
                  }>
                  -
                </button>

                {children}

                <button
                  onClick={() => setChildren(children + 1)}>
                  +
                </button>
              </li>

              <li>
                Номеров
                <button
                  onClick={() =>
                    setNumbers(Math.max(1, numbers - 1))
                  }>
                  -
                </button>

                {numbers}

                <button
                  onClick={() => setNumbers(numbers + 1)}>
                  +
                </button>
              </li>

              <button onClick={() => setFamilyOpen(false)}>
                Готово
              </button>
            </ul>
          )}
        </div>

        <h2>Итого: ${totalPrice}</h2>

        <button
          onClick={handleBooking}
          disabled={isOverLimit}
          style={{
            background: isOverLimit ? "black" : "white",
            color: isOverLimit ? "white" : "black",
            cursor: isOverLimit ? "not-allowed" : "pointer",
          }}>
          {isOverLimit
            ? "Слишком много гостей"
            : "Забронировать"}
        </button>
      </div>
    </div>
  );
}