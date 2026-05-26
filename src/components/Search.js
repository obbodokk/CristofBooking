import React from "react";
import "react-datepicker/dist/react-datepicker.css";
import { useNavigate } from "react-router-dom";

class Search extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      query: "",
      isOpen: false,
      data: [
        { country: "Сингапур", 
          cities: ["Сингапур"] },
        { country: "Германия", 
          cities: ["Берлин", "Мюнхен"] },
        { country: "Индия", 
          cities: ["Удайпур", "Мумбаи"] },
        { country: "Монако", 
          cities: ["Монте-Карло"] },
        { country: "Япония", 
          cities: ["Токио"] },
        { country: "Великобритания", 
          cities: ["Лондон"] },
        { country: "Франция", 
          cities: ["Париж", "Тулуза"] },
        { country: "ОАЭ", 
          cities: ["Дубай"] },
        { country: "Таиланд", 
          cities: ["Бангкок"] },
        { country: "Россия", 
          cities: ["Москва", "Санкт-Петербург", "Сочи"] },
        { country: "США",
           cities: ["Нью-Йорк"] },
        { country: "Бразилия",
           cities: ["Рио-де-Жанейро"] },
        { country: "Гонконг",
           cities: ["Гонконг"] },
        { country: "Швеция", 
          cities: ["Стокгольм"] },
        { country: "Испания",
           cities: ["Барселона"] },
        { country: "Нидерланды",
           cities: ["Амстердам"] },
        { country: "Италия",
           cities: ["Венеция", "Милан"] }
      ]
    };

    this.searchRef = React.createRef();
  }

  handleSearch = () => {
    const {query} = this.state;

    if (!query.trim()) return;

    this.props.navigate(
      `/hotels?city=${encodeURIComponent(query)}`
    );
  };

  handleClickOutside = (event) => {
    if (
      this.searchRef.current &&
      !this.searchRef.current.contains(event.target)
    ) {
      this.setState({ isOpen: false });
    }
  };

  componentDidMount() {
    document.addEventListener("mousedown", this.handleClickOutside);
  }

  componentWillUnmount() {
    document.removeEventListener("mousedown", this.handleClickOutside);
  }

  render() {
    return (
      <div className="search">
        <div className="wrapper">
          <input
            placeholder="Куда вы хотите поехать?"
            ref={this.searchRef}
            value={this.state.query}
            onFocus={() => this.setState({ isOpen: true })}
            onChange={(e) =>
              this.setState({
                query: e.target.value,
                isOpen: true
              })}/>

          {this.state.isOpen && (
            <ul className="table-country">
              {this.state.data
                .filter((item) =>
                  item.country
                    .toLowerCase()
                    .includes(this.state.query.toLowerCase()) ||
                  item.cities.some((city) =>
                    city
                      .toLowerCase().includes(this.state.query.toLowerCase()))).slice(0, 5)
                .flatMap((item, i) =>
                  item.cities.map((city, index) => (
                    <li
                      key={`${i}-${index}`}
                      onMouseDown={() =>
                        this.setState({
                          query: `${item.country}, ${city}`,
                          isOpen: false})}>
                      <strong>{item.country}</strong>
                      <br />
                      <small>{city}</small>
                    </li>)))}
            </ul>)}
        </div>

        <button className="find" onClick={this.handleSearch}>
          Найти
        </button>
      </div>);}
}

function withRouter(Component) {
  return function Wrapper(props) {  
    const navigate = useNavigate();
    return <Component {...props} navigate={navigate} />;};
}

export default withRouter(Search);