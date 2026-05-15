import * as ReactDOMClient from "react-dom/client"
import "./components/main.css"
import App from "./components/App"
const app = ReactDOMClient.createRoot(document.getElementById("main"))
app.render(<App/>)