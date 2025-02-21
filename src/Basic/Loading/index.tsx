import "./loading.css";

const Loading = () => {
  return (
    <div className="flex h-full w-full items-center justify-center flex-col">
      <div className="text-base mb-2 text-blue-600">Loading...</div>
      <svg
        className="spinner"
        width="28px"
        height="28px"
        viewBox="0 0 66 66"
        xmlns="http://www.w3.org/2000/svg"
      >
        <circle
          className="path stroke-blue-600 dark:stroke-blue-500"
          fill="none"
          strokeWidth="6"
          strokeLinecap="round"
          cx="33"
          cy="33"
          r="30"
        ></circle>
      </svg>
    </div>
  );
};

export default Loading;
