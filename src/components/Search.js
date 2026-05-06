import React from "react"
import DatePicker from "react-datepicker"
import "react-datepicker/dist/react-datepicker.css"

class Search extends React.Component {
    constructor(props) {
        super(props)

        this.state = {
            daterange: [null, null],
            query: "",

            data: [
                {
                    country: "Сингапур",
                    cities: ["Сингапур"]
                },
                {
                    country: "Германия",
                    cities: ["Берлин", "Мюнхен"]
                },
                {
                    country: "Индия",
                    cities: ["Удайпур", "Мумбаи"]
                },
                {
                    country: "Монако",
                    cities: ["Монте-Карло"]
                },
                {
                    country: "Япония",
                    cities: ["Токио"]
                },
                {
                    country: "Великобритания",
                    cities: ["Лондон"]
                },
                {
                    country: "Франция",
                    cities: ["Париж", "Тулуза"]
                },
                {
                    country: "ОАЭ",
                    cities: ["Дубай"]
                },
                {
                    country: "Таиланд",
                    cities: ["Бангкок"]
                },
                {
                    country: "Россия",
                    cities: ["Москва", "Санкт-Петербург", "Сочи"]
                },
                {
                    country: "США",
                    cities: ["Нью-Йорк"]
                },
                {
                    country: "Бразилия",
                    cities: ["Рио-де-Жанейро"]
                },
                {
                    country: "Гонконг",
                    cities: ["Гонконг"]
                },
                {
                    country: "Швеция",
                    cities: ["Стокгольм"]
                },
                {
                    country: "Испания",
                    cities: ["Барселона"]
                },
                {
                    country: "Нидерланды",
                    cities: ["Амстердам"]
                },
                {
                    country: "Италия",
                    cities: ["Венеция", "Милан"]
                }
            ],

            iscount: false,
            family_count: false,
            parents: 2,
            children: 0,
            numbers: 1
        }

        this.searchRef = React.createRef()
        this.familyRef = React.createRef()
    }

    render() {
        const [date_start, date_end] = this.state.daterange

        return (
            <div className="search">
            <div className="wrapper">
  <input placeholder="Куда вы хотите поехать?" ref={this.searchRef} value={this.state.query}
    onFocus={() => this.setState({ iscount: true })}
    onChange={(el) =>
        this.setState({
            query: el.target.value,
            iscount: true})}/>

{this.state.iscount && (
    <ul className="table-country">
        {this.state.data
            .filter(item => item.country.toLowerCase().includes(this.state.query.toLowerCase()) 
                  ||
                item.cities.some(city => city.toLowerCase().includes(this.state.query.toLowerCase()))).slice(0, 5).flatMap((item, i) =>
                item.cities.map((city, index) => (
                    <li key={`${i}-${index}`}
                        onMouseDown={() =>
                            this.setState({
                                query: `${item.country}, ${city}`,
                                iscount: false})}>
                        <strong>{item.country}</strong>
                        <br />
                        <small>{city}</small>
                    </li>)))}
    </ul>)}
                </div>

                <DatePicker
                    showIcon
                    icon={
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="3 3 48 50"
                        >
                            <mask id="ipSApplication0">
                                <g
                                    fill="none"
                                    stroke="#ffffff"
                                    strokeLinejoin="round"
                                    strokeWidth="4"
                                >
                                    <path
                                        strokeLinecap="round"
                                        d="M40.04 22v20h-32V22"
                                    />
                                    <path
                                        fill="#fff"
                                        d="M5.842 13.777C4.312 17.737 7.263 22 11.51 22c3.314 0 6.019-2.686 6.019-6a6 6 0 0 0 6 6h1.018a6 6 0 0 0 6-6c0 3.314 2.706 6 6.02 6c4.248 0 7.201-4.265 5.67-8.228L39.234 6H8.845l-3.003 7.777Z"
                                    />
                                </g>
                            </mask>

                            <path
                                fill="currentColor"
                                d="M0 0h48v48H0z"
                                mask="url(#ipSApplication0)"
                            />
                        </svg>
                    }
                    selectsRange
                    startDate={date_start}
                    endDate={date_end}
                    onChange={(date) =>
                        this.setState({ daterange: date })
                    }
                    placeholderText="Выберите дату"
                    minDate={new Date()}
                    customInput={
                        <input
                            readOnly
                            value={date_start && date_end ? `${date_start.toLocaleDateString()} - ${date_end.toLocaleDateString()}`: ""}
/>}/>

                <div className="wrap" ref={this.familyRef}>
                    <input
                        placeholder={`${this.state.parents} Взрослых - ${this.state.children} детей - ${this.state.numbers} номер`}
                        onFocus={() =>
                            this.setState({ family_count: true })}
                            readOnly/>

                    {this.state.family_count && (
                        <ul className="family">
                            <li className="row">
                                <span>Взрослых</span>
                                <div className="controls">
                                    <button
                                        type="button"
                                        onClick={() =>
                                            this.setState({
                                                parents:this.state.parents > 0? this.state.parents - 1: 0})}>
                                          -
                                    </button>

                                    <span>{this.state.parents}</span>

                                    <button
                                        type="button"
                                        onClick={() =>
                                            this.setState({parents: this.state.parents + 1})}>
                                        +
                                    </button>
                                </div>
                            </li>

                            <li className="row">
                                <span>Детей</span>
                                <div className="controls">
                                    <button
                                        type="button"
                                        onClick={() =>
                                            this.setState({children:this.state.children > 0? this.state.children - 1: 0})}>
                                        -
                                    </button>

                                    <span>{this.state.children}</span>

                                    <button
                                        type="button"
                                        onClick={() =>
                                            this.setState({children: this.state.children + 1})}>
                                        +
                                    </button>
                                </div>
                            </li>

                            <li className="row">
                                <span>Номера</span>
                                <div className="controls">
                                    <button
                                        type="button"
                                        onClick={() =>
                                            this.setState({numbers:this.state.numbers > 0? this.state.numbers - 1: 0})}>
                                              -
                                    </button>

                                    <span>{this.state.numbers}</span>

                                    <button
                                        type="button"
                                        onClick={() =>this.setState({numbers: this.state.numbers + 1})}>
                                          +
                                    </button>
                                </div>
                            </li>

                            <li className="done">
                                <button
                                    type="button"
                                    onClick={() =>this.setState({family_count: false})}>
                                    Готово
                                </button>
                            </li>
                        </ul>)}
                </div>

                <button className="find">
                    Найти
                </button>

            </div>
        )
    }

    componentDidMount() {
        document.addEventListener(
            "mousedown",
            this.handleClickOutside
        )
    }

    componentWillUnmount() {
        document.removeEventListener(
            "mousedown",
            this.handleClickOutside
        )
    }

    handleClickOutside = (event) => {
        if (
            this.searchRef.current &&
            !this.searchRef.current.contains(event.target)
        ) {
            this.setState({ iscount: false })
        }

        if (
            this.familyRef.current &&
            !this.familyRef.current.contains(event.target)
        ) {
            this.setState({ family_count: false })
        }
    }
}

export default Search