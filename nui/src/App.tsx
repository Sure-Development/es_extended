import { useCallback, useEffect, useState } from 'react'
import { JSONTree } from 'react-json-tree'

export default function App() {
  const [show, setShow] = useState(false)
  const [json, setJson] = useState<Record<any, any>>({})

  const handleMessage = useCallback(
    (
      e: MessageEvent<
        { type: 'toggle'; data: boolean } | { type: 'update'; data: Record<any, any> }
      >
    ) => {
      if (e.data.type === 'toggle') setShow(e.data.data)
      else if (e.data.type === 'update') setJson(e.data.data)
    },
    []
  )

  const handleKeyboard = useCallback((e: KeyboardEvent) => {
    if (e.code === 'Escape') {
      navigator.sendBeacon('https://es_extended/close', JSON.stringify({}))
    }
  }, [])

  useEffect(() => {
    navigator.sendBeacon('https://es_extended/ready', JSON.stringify({}))
  }, [])

  useEffect(() => {
    window.addEventListener('message', handleMessage)
    return () => {
      window.removeEventListener('message', handleMessage)
    }
  }, [handleMessage])

  useEffect(() => {
    document.addEventListener('keydown', handleKeyboard)
    return () => {
      document.removeEventListener('keydown', handleKeyboard)
    }
  }, [handleKeyboard])

  return (
    <>
      <div
        style={{
          opacity: show ? 1 : 0,
          width: 600,
        }}
      >
        <JSONTree data={json} />
      </div>
    </>
  )
}
