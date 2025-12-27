import { useState, useEffect, useCallback, useRef } from 'react'

interface QueueItem<T> {
  id: string
  data: T
  duration?: number
}

export default function useQueue<T>({
  defaultLimit = 6,
  defaultTimeout = 5000,
  onRemove = () => {},
}: {
  defaultLimit?: number
  defaultTimeout?: number
  onRemove?: (item: QueueItem<T>) => any
}) {
  const [waiting, setWaiting] = useState<QueueItem<T>[]>([])
  const [active, setActive] = useState<QueueItem<T>[]>([])

  const timersRef = useRef<Map<string, number>>(new Map())

  const enqueue = useCallback((data: T, customDuration?: number) => {
    const id = crypto.randomUUID()
    setWaiting((prev) => [...prev, { id, data, duration: customDuration }])
  }, [])

  useEffect(() => {
    if (active.length >= defaultLimit) return
    if (waiting.length === 0) return

    const slots = defaultLimit - active.length
    const next = waiting.slice(0, slots)

    setWaiting((prev) => prev.slice(next.length))
    setActive((prev) => [...prev, ...next])
  }, [waiting, active.length, defaultLimit])

  useEffect(() => {
    active.forEach((item) => {
      if (timersRef.current.has(item.id)) return

      const timeout = item.duration ?? defaultTimeout

      const timer = setTimeout(() => {
        onRemove(item)
        setActive((prev) => prev.filter((i) => i.id !== item.id))
        timersRef.current.delete(item.id)
      }, timeout)

      timersRef.current.set(item.id, timer)
    })
  }, [active, defaultTimeout])

  useEffect(() => {
    return () => {
      timersRef.current.forEach(clearTimeout)
      timersRef.current.clear()
    }
  }, [])

  return {
    displayItems: active,
    waitingCount: waiting.length,
    enqueue,
  }
}
