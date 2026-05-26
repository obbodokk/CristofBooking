import { useEffect, useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";

function useQuery() {
  return new URLSearchParams(useLocation().search);
}

export default function Hotels() {
  const [hotels, setHotels] = useState([]);
  const navigate = useNavigate();
  const query = useQuery();

  const cityParam = query.get("city");

  const cleanCity =
    typeof cityParam === "string" ? cityParam.split(",").pop().trim() : "";

  useEffect(() => {
    let url = "http://127.0.0.1:5000/api/hotels/";

    if (cleanCity) {
      url += `?location=${encodeURIComponent(cleanCity)}`;
    }

    fetch(url)
      .then((res) => res.json())
      .then((data) => {
        console.log("API RESPONSE:", data);

        setHotels(Array.isArray(data) ? data : []);
      })
      .catch((err) => {
        console.error("FETCH ERROR:", err);
        setHotels([]);
      });
  }, [cleanCity]);

  return (
    <div className="hotel-grid">
      {hotels.map((hotel) => (
        <div
          key={hotel.id}
          className="hotel-card"
          onClick={() => navigate(`/hotel/${hotel.id}`)}>
          <img src={hotel.image_url} alt={hotel.name} />

          <h2>{hotel.name}</h2>
          <p>{hotel.location}</p>
          <p>⭐ {hotel.rating}</p>
        </div>
      ))}
    </div>
  );
}