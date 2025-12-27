import Portal from '@/components/Portal'
import useQueue from '@/utils/useQueue'
import { useEffect, useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { useEvent } from '@/utils/useEvent'
import { fetchNui } from '@/utils/fetch'
import { CONSTS, DEFAULT_CLASSES, DEFAULT_ICON_CLASSES } from './consts'
import { cn } from '@/utils/cn'
import { Icon } from '@iconify/react'
import type { Placement } from '@/types/Placement'

const PROD = import.meta.env.PROD

type Default = { defaultLimit: number; defaultTimeout: number }
type Notification = {
  id: string
  type: keyof typeof CONSTS
  text: string
  duration?: number
}

export default function Notification({ placement }: { placement: Placement }) {
  const [defaults, setDefaults] = useState<Default>({ defaultLimit: 6, defaultTimeout: 5000 })
  const { displayItems, enqueue } = useQueue<Notification>({
    ...defaults,
    onRemove: (_) => {
      // on remove notification
      // with context item
    },
  })

  useEvent<Default>('notification/setDefaults', (defaults) => setDefaults(defaults))
  useEvent<Notification>('notification/add', (data) => enqueue(data, data.duration))

  useEffect(() => {
    ;(async () => {
      try {
        const data = await fetchNui<Default>('notification/ready')
        setDefaults(data)
      } catch {}
    })()
  }, [])

  return (
    <Portal id="Notification" placement={placement} className="flex flex-col gap-1">
      <AnimatePresence initial={false} mode="sync">
        {displayItems.map((item) => {
          const theme = CONSTS[item.data.type]
          return (
            <motion.div
              key={item.data.id}
              layout
              initial={{ opacity: 0, x: 10 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 10, animationDuration: 0.2 }}
              className={cn(DEFAULT_CLASSES, theme.classes)}
            >
              <div className={cn(DEFAULT_ICON_CLASSES, theme.iconClasses)}>
                <Icon icon={theme.icon} width={theme.iconSize} />
              </div>
              <span>{item.data.text}</span>
            </motion.div>
          )
        })}

        {!PROD && (
          <>
            <motion.div
              key="info"
              layout
              initial={{ opacity: 0, x: 10 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 10, animationDuration: 0.2 }}
              className={cn(DEFAULT_CLASSES, CONSTS.info.classes)}
            >
              <div className={cn(DEFAULT_ICON_CLASSES, CONSTS.info.iconClasses)}>
                <Icon icon={CONSTS.info.icon} width={CONSTS.info.iconSize} />
              </div>
              <span>Info</span>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </Portal>
  )
}
