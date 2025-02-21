import { useNavigate } from "react-router";

const NotFound = () => {
  const navigate = useNavigate();
	const goBack = () => {
		navigate(-1)
	}
  return <div className="flex flex-col w-full h-full items-center justify-center">
    <div className="404 text-6xl text-black font-mono font-extralight underline underline-offset-8 dark:text-white">404</div>
    <button className="pt-5" onClick={goBack}>Go back</button>
  </div>
}

export default NotFound
