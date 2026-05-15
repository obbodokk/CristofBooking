import React from "react";
import Header, {Login, Register, About} from "./Headers";
import Search from "./Search";
import Hotels from "./Hotels";
import HotelCard from "./Hotel_card";
import Back from "./back";
import {Dashboard} from "./Headers";
import {BrowserRouter as Router, Routes, Route} from "react-router-dom";
import Account from "./account";

class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {auth: !!localStorage.getItem("token"),};
  }

  setAuth = (value) => {
    this.setState({ auth: value });
  };

  render() {
    return (
      <div id="top">
        <Router>
        <Routes>

            <Route path="/" element={<> <Header auth={this.state.auth} setAuth={this.setAuth}/> <Search /> <Hotels /> </>}/>
            <Route path="/hotels" element={<> <Header auth={this.state.auth} setAuth={this.setAuth}/> <Search /> <Back /> <Hotels /></>}/>
            <Route path="/login" element={ <Login setAuth={this.setAuth} />}/>
            <Route path="/register" element={<Register />}/>
            <Route path="/about" element={<About />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/hotel/:id" element={<HotelCard />} />
            <Route path="/account" element={<Account/>} />
          </Routes>
        </Router>
      </div>
    );
  }
}

export default App;