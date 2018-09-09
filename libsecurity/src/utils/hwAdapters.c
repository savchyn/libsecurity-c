#include <sys/time.h>
#include "libsecurity/utils/utils.h"

#include "libsecurity/utils/hwAdapters.h"

#ifdef MBED_OS

// #include <mbed-drivers/mbed.h>

//todo #include "unminar/unminar.h"


//#include "minar-platform/minar_platform.h"
typedef uint32_t unminar_time_t;

static unminar_time_t unminar_getTime()
{
	time_t result; //TODO = ...
	return result;
}

static uint16_t unminar_ticks(unminar_time_t t)
{
	uint16_t result = 0; // t.ms;
	
	return result;
}

/* Use the low-power ticker to emulate gettimeofday() response. Note that this
 * is not a proper real-world clock; use it only to measure duration between
 * two time points, and not for telling the current time since 1970.
*/
int gettimeofday(struct timeval *tv, void *tz) {
	

  if (tv) {
    uint16_t ms = unminar_ticks(unminar_getTime());
    tv->tv_sec = ms / 1000;
    tv->tv_usec = (ms % 1000) * 1000;
  }

 
  return 0;
}

int16_t HwAdapters_Sleep(int32_t sec, int32_t nanosec) {
  wait_us((int64_t)(sec * 1000000 + nanosec / 1000));
  return true;
}

#else

int16_t HwAdapters_Sleep(int32_t sec, int32_t nanosec) {
  struct timespec tim;
  tim.tv_sec = sec;
  tim.tv_nsec = nanosec;

  return nanosleep(&tim, NULL);
}

#endif
